class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: :DESC)
  end

  # twilio sends a posts request to VildeIO
  def create
  end

  def test
    send_test_message_to_govind
    head :ok
  end
end
