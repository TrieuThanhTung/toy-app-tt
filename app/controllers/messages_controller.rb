class MessagesController < ApplicationController
  def index
    @recipient = User.find(params[:user_id])
    @messages = Message.involve_user(current_user.id, params[:user_id])
  end

  def create
    @message = Message.new(sender_id: current_user.id, recipient_id: params[:user_id], content: params[:content])
    if @message.save
      channel_name = [@message.sender_id.to_s, params[:user_id].to_s].sort.join("_")
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        method: 'create',
        message: @message
      })
    end
  end

  def update
    @message = Message.find(params[:id])
    @message.content = params[:content]
    if current_user.id == @message.sender_id && @message.save
      channel_name = [@message.sender_id.to_s, params[:user_id].to_s].sort.join("_")
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        method: 'update',
        message: @message
      })
    end
  end

  def destroy
    @message = Message.find(params[:id])
    if current_user.id == @message.sender_id && @message.destroy
      channel_name = [@message.sender_id.to_s, params[:user_id].to_s].sort.join("_")
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        method: 'delete',
        message: @message
      })
    end
  end
end
