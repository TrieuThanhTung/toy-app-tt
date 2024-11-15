class ChatChannel < ApplicationCable::Channel
  include MessagesHelper

  def subscribed
    reject if params[:user_id].blank?
    stream_from channel_name(private_channel(current_user, params[:user_id]))
  end

  def unsubscribed
    # TODO: Any cleanup needed when channel is unsubscribed
  end

  def create(data)
    channel_name = private_channel(current_user, params[:user_id])
    room = Room.find_or_create_by(title: channel_name) do |room|
      create_private_room(channel_name, current_user, params[:user_id])
    end
    ActiveRecord::Base.transaction do
      @message = Message.create!(sender_id: current_user, room_id: room.id, message_type: :text, content: data['message'])
      broadcast_message(private_channel(current_user, params[:user_id]),
                        'create',
                        @message)
    end
  end

  def update(data)
    @message = Message.find_by(id: data['id'])
    if !@message.nil? && current_user == @message.sender_id
      @message.content = data['message']
      if @message.save
        broadcast_message(private_channel(current_user, params[:user_id]),
                          'update',
                          @message)
      end
    end
  end

  def delete(data)
    @message = Message.find_by(id: data['id'])
    if !@message.nil? && current_user == @message.sender_id && @message.destroy
      broadcast_message(private_channel(current_user, params[:user_id]),
                        'delete',
                        @message)
    end
  end

  private
  def broadcast_message(channel, method = 'create', message)
    ActionCable.server.broadcast(channel_name(channel), {
      method: method,
      message: message
    })
  end
end
