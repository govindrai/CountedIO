require 'twilio-ruby'
require 'wit'
require 'nutritionix/api_1_1'

class Message < ApplicationRecord
  belongs_to :user




  def check_for_registration(wit_response)
    p '*' * 100
    puts wit_response
    puts wit_response[:intent]
    p '*' * 100
    if wit_response["intent"][0]["value"] == "register"
      p '*' * 100
      puts 'yes! please save me'
      p '*' * 100
    end
  end


  def do_easy_shit
    wit_response = send_message_to_wit
    intent = extract_intent(wit_response)

    if intent == 'registration'
      # do registration flow
    elsif intent == 'add_item'
      # do add_item_flo
      respond_to_user(results_json)
    else
      # send twilio response saying "I have no idea what you're talking about"
    end
  end

  # helper method which looks at a JSON response from with and extracts intent
  def extract_intent(wit_response)
    @intent ||= response["entities"]["intent"][0]["value"] if response["entities"]["intent"]
  end

  # extracts food items
  def extract_food_item(wit_response)
    food_item = wit_response["_text"]
    queryNutrionix(food_item)
  end

  def queryNutrionix(food)
    app_id = '010fcf20'
    app_key = 'f5e31860c7cc709b1ec3b1249435e70a'
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

  def send_message_to_wit
    configure_wit_client
    @client.message(self.body)
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
    @client.messages.create(
      from: @twilio_phone_number,
      to: '+19257779777',
      body: 'Hey there!',
      # url: 'localhost.com/viewmyprofile'
      # media_url: 'http://coolwildlife.com/wp-content/uploads/galleries/post-3004/Fox%20Picture%20003.jpg'
    )
  end

  def configure_twilio_client
    Twilio.configure do |config|
      config.account_sid = Rails.application.secrets.twilio_account_sid
      config.auth_token = Rails.application.secrets.twilio_auth_token
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
