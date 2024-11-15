class MessagesController < ApplicationController
  include MessagesHelper

  before_action :set_message, only: [:update, :destroy]
  def index
    @recipient = User.find(params[:user_id])
    channel_name = "private_#{[current_user.id.to_s, params[:user_id]].sort.join("_")}"
    @room = Room.find_by(title: channel_name)

    if @room.nil?
      @room = create_private_room(channel_name, current_user.id, params[:user_id])
    end
    @messages = Message.where(room_id: @room.id)
    @messages = @messages.nil? ? Array.new : @messages
  end

  def create
    channel_name = "private_#{[current_user.id.to_s, params[:user_id]].sort.join("_")}"
    @room = Room.find_by(title: channel_name)

    if @room.nil?
      create_private_room(channel_name, current_user.id, params[:user_id])
    end

    @message = Message.new(sender_id: current_user.id, room_id: @room.id, message_type: :text, content: params[:content])
    if @message.save
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        method: 'create',
        message: @message
      })
    end
  end

  def update
    @message.content = params[:content]
    if current_user.id == @message.sender_id && @message.save
      channel_name = "private_#{[current_user.id.to_s, params[:user_id]].sort.join("_")}"
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        method: 'update',
        message: @message
      })
    end
  end

  def destroy
    if current_user.id == @message.sender_id && @message.destroy
      channel_name = "private_#{[current_user.id.to_s, params[:user_id]].sort.join("_")}"
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        method: 'delete',
        message: @message
      })
    end
  end

  before_action
  def set_message
    @message = Message.find(params[:id])
  end
end
