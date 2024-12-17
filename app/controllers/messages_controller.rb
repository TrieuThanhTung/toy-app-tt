class MessagesController < ApplicationController
  include MessagesHelper

  before_action :set_message, only: [ :update, :destroy ]
  before_action :set_channel_name, only: [ :index, :create, :update, :destroy ]
  before_action :set_room_or_create, only: [ :index, :create ]

  def index
    @recipient = User.find(params[:user_id])
    @messages = Message.where(room_id: @room.id)
  end

  def create
    ActiveRecord::Base.transaction do
      message = Message.new(sender_id: current_user.id,
                             room_id: @room.id,
                             message_type: :text,
                             content: params[:content])
      message.image.attach(params[:image])
      message.save!
      sender_message = render_to_string_message("messages/sender_message",
                                                { message: message, recipient_id: params["user_id"] })
      recipient_message = render_to_string_message("messages/recipient_message", { message: message })
      message = {
        sender_message: sender_message,
        recipient_message: recipient_message,
        data: @message
      }
      broadcast_message(@channel_name, "create", message)
    rescue ActiveRecord::RecordInvalid => exception
      broadcast_error_message(@channel_name, exception.message)
    end
  end

  def update
    return broadcast_error_message(@channel_name, "Update message fail.") unless authorized_to_action?(@message, current_user.id)
    if @message.update(params[:content])
      broadcast_message(@channel_name, "update", @message)
    else
      broadcast_error_message(@channel_name, "Update message fail.")
    end
  end

  def destroy
    current_user_id = current_user.id
    if authorized_to_action?(@message, current_user_id) && @message.destroy
      broadcast_message(@channel_name, "delete", @message)
    else
      broadcast_error_message(private_channel(current_user_id, params[:user_id]), "Update message fail.")
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def set_room_or_create
    @room ||= Room.find_by(title: @channel_name) || create_private_room(@channel_name, current_user.id, params[:user_id])
  end

  def set_channel_name
    @channel_name = private_channel(current_user.id, params[:user_id])
  end
end
