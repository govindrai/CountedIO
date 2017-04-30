require 'twilio-ruby'

class Message < ApplicationRecord
  belongs_to :user

  private

  def send_test_message_to_govind
    configure_twilio_client
    @client.messages.create(
      from: @twilio_phone_number,
      to: '+19257779777',
      body: 'Hey there!',
      media_url: 'http://example.com/smileyface.jpg'
    )
  end

  def configure_twilio_client
    Twilio.configure do |config|
      config.account_sid = Rails.application.secrets.some_api_key.twilio_account_sid
      config.auth_token = Rails.application.secrets.some_api_key.twilio_auth_token
    end
    @twilio_phone_number = +19253504172
    @client = Twilio::REST::Client.new
  end


end
