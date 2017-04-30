require 'twilio-ruby'

class Message < ApplicationRecord
  belongs_to :user

  def self.send_test_message_to_govind
    self.configure_twilio_client
    @client.messages.create(
      from: @twilio_phone_number,
      to: '+19257779777',
      body: 'Hey there!',
      # url: 'localhost.com/viewmyprofile'
      # media_url: 'http://coolwildlife.com/wp-content/uploads/galleries/post-3004/Fox%20Picture%20003.jpg'
    )
  end

  def self.configure_twilio_client
    p Rails.application.secrets
    Twilio.configure do |config|
      config.account_sid = Rails.application.secrets.twilio_account_sid
      config.auth_token = Rails.application.secrets.twilio_auth_token
      p Rails.application.secrets.twilio_account_sid
    end
    @twilio_phone_number = +19253504172
    @client = Twilio::REST::Client.new
  end


end
