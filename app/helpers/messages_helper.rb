module MessagesHelper
  def create_private_room(channel_name, sender_id, recipient_id)
    ActiveRecord::Base.transaction do
      room = Room.create!(title: channel_name)
      room.save!
      Participant.create!(user_id: sender_id, room_id: room.id)
      Participant.create!(user_id: recipient_id, room_id: room.id)
      room
    rescue ActiveRecord::RecordInvalid => error
      broadcast_error_message(channel_name, error.message)
    end
  end

  def broadcast_message(channel, method = "create", message)
    ActionCable.server.broadcast(channel_name(channel), {
      method: method,
      message: message
    })
  end

  def private_channel(first_user, second_user)
    "private_#{[ first_user.to_s, second_user.to_s ].sort.join("_")}"
  end

  def channel_name(title)
    "chat_channel_#{title}"
  end

  def broadcast_error_message(channel, message)
    broadcast_message(channel, "error", {
      message: message
    })
  end

  def authorized_to_action?(message, current_user_id)
    message.present? && current_user_id == message.sender_id
  end

  def render_to_string_message(partial, data)
    ApplicationController.renderer.render(
      partial: partial,
      locals: data,
      layout: false,
      formats: [ :html ]
    )
  end
end
