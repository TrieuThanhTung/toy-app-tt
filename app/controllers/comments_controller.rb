class CommentsController < ApplicationController
  def create
    @micropost = params[:comment_id] ? Micropost.find(params[:comment_id])
                   : Micropost.find(params[:micropost_id])
    new_comment = @micropost.comments.build(comment_params)
    new_comment.user = current_user
    respond_to do |format|
      if new_comment.save
        flash[:success] = "Comment added successfully"
        format.html { redirect_to @micropost, status: :created }
      else
        flash[:danger] = new_comment.errors.full_messages.to_sentence
        format.html { redirect_to @micropost, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  private
  def comment_params
    params.require(:micropost).permit(:content)
  end
end
