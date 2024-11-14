class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    first_user = params[:user_id].to_s
    second_user = current_user.to_s
    channel_name = "private_#{[first_user, second_user].sort.join("_")}"
    stream_from "chat_channel_#{channel_name}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create(data)
    channel_name = "private_#{[current_user.to_s, params[:user_id].to_s].sort.join("_")}"
    room = Room.find_by(title: channel_name)
    @message = Message.create!(sender_id: current_user, room_id: room.id, message_type: :text, content: data['message'])
    if @message.save
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        method: 'create',
        message: @message
      })
    end
  end

  def update(data)
    @message = Message.find_by(id: data['id'])
    @message.content = data['message']
    if current_user == @message.sender_id && @message.save
      channel_name = "private_#{[current_user.to_s, params[:user_id].to_s].sort.join("_")}"
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        method: 'update',
        message: @message
      })
    end
  end

  def delete(data)
    @message = Message.find_by(id: data['id'])
    if current_user.id == @message.sender_id && @message.destroy
      first_user = params[:user_id].to_s
      second_user = current_user.to_s
      channel_name = "private_#{[first_user, second_user].sort.join("_")}"
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        method: 'delete',
        message: @message
      })
    end
  end
end
