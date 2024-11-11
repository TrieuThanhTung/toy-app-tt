class MessagesController < ApplicationController
  def index
    @messages = Message.involve_user(current_user.id, params[:user_id])
  end
end
