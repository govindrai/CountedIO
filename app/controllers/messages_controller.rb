class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: :DESC)
  end

  # twilio sends a posts request to VildeIO
  def create
    body = message_params[:Body]
    phone_number = message_params[:From]
    @message = Message.create(body: body, phone_number: phone_number)
    @message.do_easy_shit
  end

  def test_twilio_send
    @message = Message.new(body: "Hey there!", phone_number: '+19257779777')
    @message.send_test_message_to_govind
    @message.save
    head :ok
  end

  def test_register_intent
    @message = Message.create!(phone_number: ENV["GOVIND_PHONE_NUMBER"], body: "reset")
    @message.do_easy_shit
    head :ok
  end

  def test_add_item_intent
    @message = Message.create!(phone_number: ENV["GOVIND_PHONE_NUMBER"], body: "Add 14 Big Mac")
    @message.do_easy_shit
    head :ok
  end

  def test_profile_intent
    @message = Message.create!(phone_number: ENV["GOVIND_PHONE_NUMBER"], body: "I would like to see my profile")
    p @message
    @message.do_easy_shit
    head :ok
  end




  private

  def message_params
    params.permit(:Body, :From)
  end
end
