class MessagesController < ApplicationController
  def index
    @recipient = User.find(params[:user_id])
    @messages = Message.involve_user(current_user.id, params[:user_id])
  end

  def create
    @messages = Message.new(sender_id: current_user.id, recipient_id: params[:user_id], content: params[:content])
    if @messages.save
      channel_name = [@messages.sender_id.to_s, params[:user_id].to_s].sort.join("_")
      ActionCable.server.broadcast("chat_channel_#{channel_name}", {
        method: 'create',
        message: @messages
      })
    end
  end

  def update
    @message = Message.find(params[:id])
    @message.content = params[:content]
    respond_to do |format|
      if current_user.id == @message.sender_id && @message.save
        ActionCable.server.broadcast("chat_channel_#{channel_name}", {
          method: 'uppdate',
          message: @messages
        })
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("message_#{@message.id}",
                                                    partial: 'messages/message',
                                                    locals: { message: @message }
                                                    )
        }
        format.html { redirect_to users_path, notice: 'Message was successfully destroyed.' }
      else
        format.html { redirect_to users_path, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    respond_to do |format|
      if current_user.id == @message.sender_id && @message.destroy
        format.turbo_stream {
          render turbo_stream: turbo_stream.remove("message_#{@message.id}")
        }
        format.html { redirect_to users_path, notice: 'Message was successfully destroyed.' }
      else
        format.html { render action: "destroy" }
      end
    end
  end
end
