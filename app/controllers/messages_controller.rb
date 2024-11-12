class MessagesController < ApplicationController
  def index
    @recipient = User.find(params[:user_id])
    @messages = Message.involve_user(current_user.id, params[:user_id])
  end

  def create
    @messages = Message.new(sender_id: current_user.id, recipient_id: params[:user_id], content: params[:content])
    if @messages.save
      channel_name = [@messages.sender_id.to_s, params[:user_id].to_s].sort.join("_")
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        message: @messages
      })
    end
  end
end
