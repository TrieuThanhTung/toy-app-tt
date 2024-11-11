class MessagesController < ApplicationController
  def index
    @messages = Message.involve_user(current_user.id, params[:user_id])
  end

  def create
    @messages = Message.new(sender_id: current_user.id, recipient_id: params[:user_id], content: params[:content])
    respond_to do |format|
      if @messages.save
        format.html { redirect_to user_messages_url(current_user), notice: 'Message was successfully sent.', status: :created }
      else
        format.html { redirect_to user_messages_url(current_user), status: :unprocessable_entity }
      end
    end
  end
end
