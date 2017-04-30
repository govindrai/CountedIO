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

  def test_wit_send
    @message = Message.new(body: "I would like to register")
    @message.do_easy_shit
    head :ok
  end




  private

  def message_params
    params.permit(:Body, :From)
  end
end
