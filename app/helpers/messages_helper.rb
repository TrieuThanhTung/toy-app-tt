module MessagesHelper
  def create_private_room(channel_name, sender_id, recipient_id)
    room = Room.create!(title: channel_name)
    room.save!
    Participant.create!(user_id: sender_id, room_id: room.id)
    Participant.create!(user_id: recipient_id, room_id: room.id)
    room
  end
end
