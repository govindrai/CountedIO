require 'twilio-ruby'
require 'wit'
require 'nutritionix/api_1_1'
require 'json'

class Message < ApplicationRecord
  after_create :message_wit

  # Takes a path based on intent
  def intent_controller
    intent = extract_intent
    @user = User.find_by(phone_number: self.phone_number)

    if intent == 'register' || TempUser.find_by(phone_number: self.phone_number)
      register_user
    elsif intent == 'add_meal'
      add_meal
    elsif intent == 'caloric_information'
      # do something
    elsif intent == 'get_profile'
      @response_to_user = @user.generate_link_to_profile
    else
      # send twilio response saying "I have no idea what you're talking about"
    end
    reply
  end

  def reply
    configure_twilio_client
    @twilio_client.messages.create(
      to: self.phone_number,
      from: ENV["TWILIO_PHONE_NUMBER"],
      body: @response_to_user
    )
  end

  def register_user
    return "You are already registered!" if User.find_by(phone_number: self.phone_number)

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
        @temp_user = nil
        message = "Your profile has been created"
      elsif @temp_user.height_inches
        @temp_user.weight_pounds = self.body
        message = "What is your target weight?"
      elsif @temp_user.sex
        @temp_user.height_inches = self.body
        message = "What is your current weight?"
      elsif @temp_user.age
        @temp_user.sex = self.body
        message = "How tall are you in inches?"
      elsif @temp_user.name
        @temp_user.age = self.body
        message = "What is your sex?"
      elsif @temp_user
        @temp_user.name = self.body
        message = "How old are you?"
      end
      @temp_user.save if @temp_user
    else
      @temp_user = TempUser.create(phone_number: self.phone_number)
      message = "Hey There!\nWhat is your name?\nYou can also say 'reset' or 'start over' at anytime to restart."
    end
    @response_to_user = message
  end

  # looks at a JSON response from wit.ai and extracts intent
  def extract_intent
    @intent ||= self.json_wit_response["entities"]["intent"][0]["value"] if self.json_wit_response["entities"]["intent"]
    puts "INTENT = #{@intent}" #remove after debugging
    @intent
  end

  # looks at the wit response, parses out foods, quantities and units into an array
  def extract_food
    foods = self.json_wit_response["entities"]["food_description"]
    foods_array = []
    foods.each do |food|
      entities = food["entities"]
      food = entities["food"] ? entities["food"][0]["value"] : nil
      quantity = entities["number"] ? entities["number"][0]["value"] : 1
      unit = entities["unit"] ? entities["unit"][0]["value"] : nil
      foods_array.push({
        food: food,
        quantity: quantity,
        unit: unit
      })
    end
    foods_array
  end

  # queries nutritionix and extracts calories from output
  def extract_calories(food)
    nutritionix_response = queryNutritionix(food)
    nutritionix_response = JSON.parse(nutritionix_response.to_s)
    nutritionix_response["hits"][0]["fields"]["nf_calories"]
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

  def add_meal
    foods_array = extract_food
    message = "Thanks for sharing! We have added "
    foods_array.each do |food_obj|
      calories = extract_calories(food_obj[:food].singularize)

      Meal.create({
        user: @user,
        food_name: food_obj[:food],
        calories: calories,
        quantity: food_obj[:quantity],
        meal_type: 'BreakfastCHANGETHIS'
        })

      message += "#{food_obj[:quantity]} #{food_obj[:food]} (#{extract_calories(food_obj[:food]) * food_obj[:quantity].to_f} calories), "
    end
    @response_to_user = message.chop(", ") + "!"
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

  private

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
