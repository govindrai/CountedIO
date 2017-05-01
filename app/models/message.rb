require 'twilio-ruby'
require 'wit'
require 'nutritionix/api_1_1'
require 'pp'
require 'json'

class Message < ApplicationRecord

  def do_easy_shit
    send_message_to_wit
    intent = extract_intent; puts "INTENT = #{intent}"

    if intent == 'register' || TempUser.find_by(phone_number: self.phone_number)
      if User.find_by(phone_number: self.phone_number)
        response = "You are already registered!"
      else
        response = register_user
      end
    elsif intent == 'add_item'
      set_add_intent_reply
    elsif intent == 'caloric_information'
      # do something
    else
      # send twilio response saying "I have no idea what you're talking about"
    end
    reply_to_user
  end

  def reply_to_user
    configure_twilio_client
    @twilio_client.messages.create(
      to: self.phone_number,
      from: ENV["TWILIO_PHONE_NUMBER"],
      body: @response_to_user
      # ,
      # media_url: "http://twilio.com/heart.jpg"
    )
  end

  def register_user
    @temp_user = TempUser.find_by(phone_number: self.phone_number)

    if self.body == "reset" || self.body == 'Reset'
      @temp_user.destroy if @temp_user
      @temp_user = nil
    end

    save_registration_input
    set_registration_reply
  end

  def save_registration_input
    if @temp_user
      if @temp_user.target_weight_pounds
        #Do nothing simply pass onto second phase
      elsif @temp_user.weight_pounds
        @temp_user.target_weight_pounds = self.body
      elsif @temp_user.height_inches
        @temp_user.weight_pounds = self.body
      elsif @temp_user.sex
        @temp_user.height_inches = self.body
      elsif @temp_user.age
        @temp_user.sex = self.body
      elsif @temp_user.name
        @temp_user.age = self.body
      elsif @temp_user
        @temp_user.name = self.body
      end
      @temp_user.save
    else
      @temp_user = TempUser.create(phone_number: self.phone_number)
    end
  end

  def set_registration_reply
    p @temp_user
    if @temp_user.target_weight_pounds
      #Save
      @user = User.new(name: @temp_user.name, phone_number: @temp_user.phone_number, age: @temp_user.age, weight_pounds: @temp_user.weight_pounds, height_inches: @temp_user.height_inches, target_weight_pounds: @temp_user.target_weight_pounds, sex: @temp_user.sex)
      @user.save
      @temp_user.destroy
      message = "Your profile has been created"
    elsif @temp_user.weight_pounds
      message = "What is your target weight?"
    elsif @temp_user.height_inches
      message = "What is your current weight?"
    elsif @temp_user.sex
      message = "How tall are you in inches?"
    elsif @temp_user.age
      message = "What is your sex?"
    elsif @temp_user.name
      message = "How old are you?"
    else
      message = "Hey There!\nWhat is your name?\nAlso, say 'reset' at anytime to restart!"
    end
    @response_to_user = message
  end

  # looks at a JSON response from wit.ai and extracts intent
  def extract_intent
    @intent ||= self.json_wit_response["entities"]["intent"][0]["value"] if self.json_wit_response["entities"]["intent"]
  end

  def extract_calories(food)
    p nutritionix_response = queryNutritionix(food)
  end

  def extract_food
    foods = self.json_wit_response["entities"]["food_description"]
    foods_array = []
    food_description_entities.each do |food|
      entities = food["entities"]
      food = entities["food"] ? entities["food"][0]["value"] : nil
      quantity = entities["number"] ? entities["number"][0]["value"] : nil
      unit = entities["unit"] ? entities["unit"][0]["value"] : nil
      foods_array.push({
        food: food,
        quantity: quantity,
        unit: unit
      })
    end
    foods_array
  end

  def queryNutritionix(food)
    app_id = ENV["NUTRITIONIX_APP_ID"]
    app_key = ENV["NUTRITIONIX_APP_KEY"]
    provider = Nutritionix::Api_1_1.new(app_id, app_key)

    search_params = {
      offset: 0,
      limit: 1,
      fields: ['item_name', 'nf_calories'],
      query: food
    }

    results_json = provider.nxql_search(search_params)
    p results_json
    p '*' * 100
    puts "Results: #{results_json}"
    p '*' * 100
    results_json
  end

  def set_add_intent_reply
    foods_array = extract_food
    add_intent_reply = "Thanks for sharing! We have added"
    foods_array.each do |food_obj|
      extract_calories(food_obj.food)
    end
  end
  # sends sms to wit, updates the messages table
  def send_message_to_wit
    configure_wit_client
    wit_response = @wit_client.message(self.body)
    self.update(json_wit_response: wit_response)
    # #User messages
    # p "*" * 50
    # p "Response 1"
    # rsp = @client.converse('my-user-session-42', self.body, {})
    # puts("Yay, got Wit.ai response: #{rsp}")

    # p "*" * 50
    # p "Response 2"
    # #Sever Applies context
    # rsp = @client.converse('my-user-session-42', {intent: "register"})
    # puts("Yay, got Wit.ai response: #{rsp}")

    # p "*" * 50
    # p "Response 3"
    # #user message
    # rsp = @client.converse('my-user-session-42', 'Govind Rai', {intent: "register"})
    # puts("Yay, got Wit.ai response: #{rsp}")

    # p "*" * 50
    # p "Response 4"
    # #server applies context
    # rsp = @client.converse('my-user-session-42', {intent: "register", name: "Govind Rai"})
    # puts("Yay, got Wit.ai response: #{rsp}")

    # p "*" * 50
    # p "Response 5"
    # #user message
    # rsp = @client.converse('my-user-session-42', {intent: "register", name: "Govind Rai"})
    # puts("Yay, got Wit.ai response: #{rsp}")

    # p "*" * 50
    # p "Response 6"
    # #user message
    # rsp = @client.converse('my-user-session-42', "20", {intent: "register", name: "Govind Rai"})
    # puts("Yay, got Wit.ai response: #{rsp}")

    # p "*" * 50
    # p "Response 7"
    # #user message
    # rsp = @client.converse('my-user-session-42', {intent: "register", name: "Govind Rai", age: "20"})
    # puts("Yay, got Wit.ai response: #{rsp}")
  end

  def send_test_message_to_govind
    configure_twilio_client
    @twilio_client.messages.create(
      from: @twilio_phone_number,
      to: ENV["GOVIND_PHONE_NUMBER"],
      body: 'Hey there!',
      # url: 'localhost.com/viewmyprofile'
      # media_url: 'http://coolwildlife.com/wp-content/uploads/galleries/post-3004/Fox%20Picture%20003.jpg'
    )
  end

  # a sample api responses
  # useful for testing against the data structures
  def sample_twilio_response
  end

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

  def sample_nutrionix_response
  end

  def configure_twilio_client
    Twilio.configure do |config|
      config.account_sid = ENV["TWILIO_ACCOUNT_SID"]
      config.auth_token = ENV["TWILIO_AUTH_TOKEN"]
    end
    @twilio_phone_number = ENV["TWILIO_PHONE_NUMBER"]
    @twilio_client = Twilio::REST::Client.new
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
end
