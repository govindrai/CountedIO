require 'twilio-ruby'
require 'wit'
require 'nutritionix/api_1_1'
require 'json'

class Message < ApplicationRecord
  after_create :message_wit, :set_user, :intent_controller

  # Takes a path based on intent
  def intent_controller
    intent = extract_intent

    case intent
    when 'unknown_user'
      ask_to_register
    when 'registration_in_progress', 'register'
      register_user
    when 'add_meal'
      add_meal
    when 'caloric_information'
      get_caloric_information
    when 'get_profile'
      @response_to_user = @user.generate_link_to_profile
    when 'capabilities'
      display_capabilities
    when 'how_to'
      display_how_to
    when 'get_calories_summary'
      @response_to_user = @user.get_calories_summary
    else
      @response_to_user = "I HAVE NO IDEA WHAT YOU'RE TALKING ABOUT"
    end
  end

  def add_meal
    foods_array = extract_food
    message = "Thanks for sharing! We have added "
    message_fail = ""
    foods_array.each do |food_obj|
      if food_obj[:food] == "User Defined Calories"
        puts "MADE IT INTO USER DEFINED CALOR"
        Meal.create({
          user: @user,
          food_name: food_obj[:food],
          calories: food_description[:calories],
          quantity: food_obj[:quantity]
          meal_type: 'Snack'
        })
        message = "We have added #{calories} to today's calories."
      elsif food_obj[:calories]
        total_calories =  (food_obj[:calories] * food_obj[:quantity].to_f).round
        Meal.create({
          user: @user,
          food_name: food_obj[:food],
          calories: total_calories,
          quantity: food_obj[:quantity]
          meal_type: 'BreakfastCHANGETHIS'
        })
        message += "#{food_obj[:original_description]} (#{total_calories} calories), "
      else
        message_fail += "#{food_obj[:food]}, "
      end
    end
    message.chomp!(", ")
    if message_fail != ""
      message+= "😭 Sorry, we couldn't find the following items in the database #{message_fail.chomp(", ")}. If possible, try to be even more specific. You can also say things like 'Add 50 calories' if this isn't working out. 👍"
    end
    @response_to_user = message
  end

  def get_caloric_information
    foods_array = extract_food
    message = ""
    foods_array.each do |food_obj|
      if food_obj[:calories]
        total_calories =  (food_obj[:calories] * food_obj[:quantity].to_f).round
        message += "#{food_obj[:original_description]} has/have #{total_calories} calories.\n"
      else
        message += "I'm sorry we weren't able to find #{food_obj[:original_description]} in the database"
      end
    end
    @response_to_user = message
  end

  def reply_to_user
    configure_twilio_client
    @twilio_client.messages.create(
      to: self.phone_number,
      from: ENV["TWILIO_PHONE_NUMBER"],
      body: @response_to_user
    )
  end

  def reply_to_user_gif
    configure_twilio_client
    @twilio_client.messages.create(
      to: self.phone_number,
      from: ENV["TWILIO_PHONE_NUMBER"],
      body: "_",
      media_url: @response_to_user
    )
  end

  def register_user
    return @response_to_user = "You are already registered!" if User.find_by(phone_number: self.phone_number)

    @temp_user = TempUser.find_by(phone_number: self.phone_number)

    if self.body == "reset" || self.body == 'Reset'
      @temp_user.destroy if @temp_user
      @temp_user = nil
    end

    if @temp_user
      if @temp_user.weight_pounds
        @temp_user.target_weight_pounds = self.body
        @user = User.create(name: @temp_user.name, phone_number: @temp_user.phone_number, age: @temp_user.age, weight_pounds: @temp_user.weight_pounds, height_inches: @temp_user.height_inches, target_weight_pounds: @temp_user.target_weight_pounds, sex: @temp_user.sex)
        @temp_user.destroy
        message = "Your profile has been created"
      else
        if @temp_user.height_inches
          @temp_user.weight_pounds = self.body
          message = "Last question...what is your target weight? 🤔🤔"
        elsif @temp_user.sex
          @temp_user.height_inches = self.body
          message = "What is your current weight?"
        elsif @temp_user.age
          @temp_user.sex = self.body
          message = "How tall are you in inches?"
        elsif @temp_user.name
          @temp_user.age = self.body
          message = "And, what is your sex?"
        elsif @temp_user
          @temp_user.name = self.body
          message = "Thanks, #{@temp_user.name}. How old are you?"
        end
        @temp_user.save
      end
    else
      @temp_user = TempUser.create(phone_number: self.phone_number)
      message = %Q(Hi there! My name is Vilde, your very-own wellness assistant. 🏋️. I’m very excited 🤗 to help you become more conscience of your eating habits and achieve your health goals😀.\n\nIn order to help, I will ask you some basic wellness questions.\n\nFirst, what should I call you? (say "reset" at any time if you make a mistake))
    end
    @response_to_user = message
  end

  # looks at a JSON response from wit.ai and extracts intent
  def extract_intent
    @intent ||= self.json_wit_response["entities"]["intent"][0]["value"] if self.json_wit_response["entities"]["intent"]
    if !@user
      @intent = "unknown_user" if @intent != "register" && !TempUser.find_by(phone_number: self.phone_number)
      @intent = 'registration_in_progress' if TempUser.find_by(phone_number: self.phone_number)
    end
    puts "INTENT = #{@intent}" #remove after debugging
    @intent
  end

  # looks at the wit response, parses out foods, quantities and units into an array
  def extract_food
    foods = self.json_wit_response["entities"]["food_description"]

    foods_array = []

    foods.each do |food_hash|
      entities = food_hash["entities"]
      food = entities["food"] ? entities["food"][0]["value"] : nil
      if food == 'calories'
        calories = entities["number"] ? entities["number"][0]["value"] : 1
        food = "User Defined Calories"
      else
        calories = extract_calories(food)
      end
      quantity = entities["number"] ? entities["number"][0]["value"] : 1
      unit = entities["unit"] ? entities["unit"][0]["value"] : nil
      original_description = food_hash["value"]

      foods_array.push({
        food: food,
        quantity: quantity,
        unit: unit,
        calories: calories,
        original_description: original_description
      })
    end
    foods_array
  end

  # queries nutritionix and extracts calories from output
  def extract_calories(food)
    nutritionix_response = queryNutritionix(food)
    nutritionix_response = JSON.parse(nutritionix_response.to_s)
    nutritionix_response = nutritionix_response["hits"].count > 0 ? nutritionix_response["hits"][0]["fields"]["nf_calories"] : nil
  end

  def queryNutritionix(food)
    configure_nutritionix_client

    search_params = {
      offset: 0,
      limit: 1,
      fields: ['item_name', 'nf_calories'],
      query: food
    }

    @nutritionix_client.nxql_search(search_params)
  end

  # sends sms to wit, updates the messages table
  def message_wit
    configure_wit_client
    wit_response = @wit_client.message(self.body)
    self.update(json_wit_response: wit_response)
  end

  # useful for checking if Twilio is working
  # useful for testing different message parameters such as url/media_url
  def sms_govind
    configure_twilio_client
    @twilio_client.messages.create(
      from: ENV["TWILIO_PHONE_NUMBER"],
      to: ENV["GOVIND_PHONE_NUMBER"],
      body: 'Show me my profile',
      # url: 'localhost.com/viewmyprofile'
      # media_url: 'http://coolwildlife.com/wp-content/uploads/galleries/post-3004/Fox%20Picture%20003.jpg'
    )
  end

  def display_capabilities
    messages = [
      "You can track food by telling me what you ate. You can say things like 'I just had an apple, three slices of bread, and peanut butter'. When you wanna see you profile just simply ask me for it.",
      "You can add calories by telling me something like 'Add 400 calories please' or you can request nutritional information of a given food by asking 'How many calories are in a coke'",
      "Ask me how many calories you have consumed today or tell me what you ate. I will record it all!", "Say something like 'I just ate a coke, three waffles and a cup of coffee'"
    ]
    @response_to_user = messages.sample
  end

  def display_how_to
    @response_to_user = "Adding food: \"I just ate grilled chicken breast\"\n"
    @response_to_user += "Show profile: \"Show me my profile\"\n"
    @response_to_user += "Registering: \"I want to register\"\n"
    @response_to_user += "Get daily calories: \"How many calories have I had today\"\n"
    @response_to_user += "Get caloric content: \"How many calories are in an apple\"\n"
    @response_to_user += "Add calories: \"Add 500 calories\"\n"
  end

  def ask_to_register
    @response_to_user = %Q(
    Hey there! We'd love to help you, but you need to be registered!\n\nReady to register? Just say "Register"
    )
    # @response_to_user = "https://media.giphy.com/media/zCmxiQtydu8kE/giphy.gif"
    # reply_to_user_gif
  end

  private

  def set_user
    @user = User.find_by(phone_number: self.phone_number)
  end

  # sample api response, useful for studying/querying
  def sample_twilio_response
  end

  # sample api response, useful for studying/querying
  def sample_wit_response
    JSON.parse('{
      "msg_id" : "d5c2227b-1a6c-4384-85d7-eec2820e65dd",
      "_text" : "I ate an apple, three olives, and a slice a bun",
      "entities" : {
        "food_description" : [ {
          "confidence" : 0.9987320073552927,
          "entities" : {
            "food" : [ {
              "confidence" : 0.9354258378052169,
              "type" : "value",
              "value" : "apple"
            } ]
          },
          "type" : "value",
          "value" : "an apple"
        }, {
          "confidence" : 0.997242556612624,
          "entities" : {
            "number" : [ {
              "confidence" : 1,
              "value" : 3,
              "type" : "value"
            } ],
            "food" : [ {
              "confidence" : 0.9165590880096315,
              "type" : "value",
              "value" : "olives",
              "suggested" : true
            } ]
          },
          "type" : "value",
          "value" : "three olives",
          "suggested" : true
        }, {
          "confidence" : 0.9953965565977307,
          "entities" : {
            "units" : [ {
              "confidence" : 1,
              "type" : "value",
              "value" : "slice"
            } ],
            "food" : [ {
              "confidence" : 0.9438404939605672,
              "type" : "value",
              "value" : "bun",
              "suggested" : true
            } ]
          },
          "type" : "value",
          "value" : "a slice a bun",
          "suggested" : true
        } ],
        "intent" : [ {
          "confidence" : 0.9999998855726199,
          "value" : "add_item"
        } ]
      }
    }')
  end

  # sample api response, useful for studying/querying
  def sample_nutrionix_response
  end

  def configure_twilio_client
    account_sid = ENV["TWILIO_ACCOUNT_SID"]
    auth_token = ENV["TWILIO_AUTH_TOKEN"]
    @twilio_client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def configure_wit_client
    actions = {
      send: -> (request, response) {
        puts("sending... #{response['text']}")
      },
      my_action: -> (request) {
        return request['context']
      },
    }

    @wit_client = Wit.new(access_token: ENV["WIT_ACCESS_TOKEN"], actions: actions)
  end

  def configure_nutritionix_client
    app_id = ENV["NUTRITIONIX_APP_ID"]
    app_key = ENV["NUTRITIONIX_APP_KEY"]
    @nutritionix_client = Nutritionix::Api_1_1.new(app_id, app_key)
  end

end
