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
    @message = Message.new()
    @message.send_test_message_to_govind
    head :ok
  end

  def test_register_intent
    @message = Message.new(phone_number: ENV["GOVIND_PHONE_NUMBER"], body: "reset")
    @message.do_easy_shit
    head :ok
  end

  def test_add_item_intent
    @message = Message.new(phone_number: ENV["GOVIND_PHONE_NUMBER"], body: "I ate a bananas")
    @message.do_easy_shit
    head :ok
  end




  private

  def message_params
    params.permit(:Body, :From)
  end
end
