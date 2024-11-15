module MessagesHelper
  def create_private_room(channel_name, sender_id, recipient_id)
    ActiveRecord::Base.transaction do
      room = Room.create!(title: channel_name)
      room.save!
      Participant.create!(user_id: sender_id, room_id: room.id)
      Participant.create!(user_id: recipient_id, room_id: room.id)
      room
    end
  end

  def private_channel(first_user, second_user)
    "private_#{[first_user.to_s, second_user.to_s].sort.join("_")}"
  end

  def channel_name(title)
    "chat_channel_#{title}"
  end
end
