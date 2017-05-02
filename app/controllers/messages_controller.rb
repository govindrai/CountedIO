class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: :DESC)
  end

  # twilio sends a posts request to VildeIO
  def create
    body = message_params[:Body]
    phone_number = message_params[:From]
    @message = Message.create(body: body, phone_number: phone_number)
    @message.reply_to_user
    head :ok
  end

  def test_twilio_send
    @message = Message.new(body: "Hey there!", phone_number: ENV["GOVIND_PHONE_NUMBER"])
    @message.send_test_message_to_govind
    @message.save
    head :ok
  end

  def test_register_intent
    @message = Message.create!(phone_number: ENV["GOVIND_PHONE_NUMBER"], body: "reset")
    @message.reply_to_user
    head :ok
  end

  def test_add_item_intent
    @message = Message.create!(phone_number: ENV["GOVIND_PHONE_NUMBER"], body: "I ate five cookies, a waffle, and 42 slices of cheese and an orange")
    @message.reply_to_user
    head :ok
  end

  def test_profile_intent
    @message = Message.create!(phone_number: ENV["GOVIND_PHONE_NUMBER"], body: "I would like to see my profile")
    @message.reply_to_user
    head :ok
  end

  def test_caloric_information_intent
    @message = Message.create!(phone_number: ENV["GOVIND_PHONE_NUMBER"], body: "How many calories in a Big Mac?")
    @message.reply_to_user
    head :ok
  end

  private

  def message_params
    params.permit(:Body, :From)
  end
end
