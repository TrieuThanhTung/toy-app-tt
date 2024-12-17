class ChatChannel < ApplicationCable::Channel
  include MessagesHelper

  def subscribed
    user_id = params[:user_id]
    reject if user_id.blank?
    stream_from channel_name(private_channel(current_user, user_id))
  end

  def unsubscribed
    # TODO: Any cleanup needed when channel is unsubscribed
  end

  def create(data)
    user_id = params[:user_id]
    channel_name = private_channel(current_user, user_id)
    room = Room.find_or_create_by(title: channel_name) do |room|
      create_private_room(channel_name, current_user, user_id)
    end
    ActiveRecord::Base.transaction do
      @message = Message.new(sender_id: current_user, room_id: room.id, message_type: :text, content: data["message"])
      @message.save!
      sender_message = render_to_string_message("messages/sender_message",
                                                { message: @message, recipient_id: params["user_id"] })
      recipient_message = render_to_string_message("messages/recipient_message", { message: @message })
      message = {
        sender_message: sender_message,
        recipient_message: recipient_message,
        data: @message
      }
      broadcast_message(channel_name, "create", message)
    rescue ActiveRecord::RecordInvalid => exception
      broadcast_error_message(channel_name, exception.message)
    end
  end

  def update(data)
    @message = set_message data
    channel_name = private_channel(current_user, params[:user_id])
    return broadcast_error_message(channel_name,
                                   "Update message fail.") unless authorized_to_action?(@message, current_user)
    if @message.update(content: data["message"])
      broadcast_message(channel_name, "update", @message)
    else
      broadcast_error_message(channel_name, "Update message fail.")
    end
  end

  def delete(data)
    @message = set_message data
    channel_name = private_channel(current_user, params[:user_id])
    if authorized_to_action?(@message, current_user) && @message.destroy
      broadcast_message(channel_name, "delete", @message)
    else
      broadcast_error_message(channel_name, "Delete message fail.")
    end
  end

  private

  def set_message(data)
    Message.find_by(id: data["id"])
  end
end
