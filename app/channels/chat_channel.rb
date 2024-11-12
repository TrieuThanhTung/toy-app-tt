class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    first_user = params[:user_id].to_s
    second_user = current_user.to_s
    channel_name = [first_user, second_user].sort.join("_")
    stream_from "chat_channel_#{channel_name}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
