require 'twilio-ruby'
require 'wit'

class Message < ApplicationRecord
  belongs_to :user



  def do_easy_shit
    wit_response = send_message_to_wit
  end



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


end
