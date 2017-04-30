require 'twilio-ruby'
require 'wit'
require 'nutritionix/api_1_1'

class Message < ApplicationRecord
  belongs_to :user

  def do_easy_shit
    send_message_to_wit
    wit_response = self.WIT_JSON_output

    intent = extract_intent(wit_response)

    if intent == 'registration'
      # do registration flow
    elsif intent == 'add_item'
      nutritionix_response = queryNutritionix
      send_test_reply_to_user
      # do some calculations based on serving sizes etc. then reply to user
      # reply_to_user()
    else
      # send twilio response saying "I have no idea what you're talking about"
    end
  end

  # looks at a JSON response from wit.ai and extracts intent
  def extract_intent
    @intent ||= self.WIT_JSON_output["entities"]["intent"][0]["value"] if self.WIT_JSON_output["entities"]["intent"]
  end

  # extracts food item(s) from wit_response
  def extract_food_item
    # this needs to work for multiple foods
    # this also needs to select food descriptions and not the whole text
    food_item = self.WIT_JSON_output["_text"]
  end

  # extracts calories from nutritionix_response
  def extract_calories
  end

  def queryNutritionix
    food = extract_food_item
    app_id = Rails.application.secrets.nutritionix_app_id
    app_key = Rails.application.secrets.nutritionix_app_key
    provider = Nutritionix::Api_1_1.new(app_id, app_key)

    search_params = {
      offset: 0,
      limit: 3,
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

  # sends sms to wit, updates the messages table
  def send_message_to_wit
    configure_wit_client
    wit_response = @client.message(self.body)
    self.update(WIT_JSON_output: wit_response)
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

  def send_test_reply_to_user

  end

  def send_test_message_to_govind
    configure_twilio_client
    @client.messages.create(
      from: @twilio_phone_number,
      to: '+19257779777',
      body: 'Hey there!',
      # url: 'localhost.com/viewmyprofile'
      # media_url: 'http://coolwildlife.com/wp-content/uploads/galleries/post-3004/Fox%20Picture%20003.jpg'
    )
  end

  def configure_twilio_client
    p Rails.application.secrets
    Twilio.configure do |config|
      config.account_sid = Rails.application.secrets.twilio_account_sid
      config.auth_token = Rails.application.secrets.twilio_auth_token
      p Rails.application.secrets.twilio_account_sid
    end
    @twilio_phone_number = '+19253504172'
    @client = Twilio::REST::Client.new
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

    @client = Wit.new(access_token: Rails.application.secrets.wit_access_token, actions: actions)
  end

  # a sample api responses
  # useful for testing against the data structures
  def sample_twilio_response
  end

  def sample_WIT_response
  end

  def sample_nutrionix_response
  end

end
