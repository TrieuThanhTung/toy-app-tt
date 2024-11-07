class CommentsController < ApplicationController
  def create
    @micropost = Micropost.find(params[:comment_id] || params[:micropost_id])
    new_comment = @micropost.comments.build(comment_params)
    new_comment.user = current_user
    respond_to do |format|
      if new_comment.save
        format.turbo_stream {
          if request.fullpath.include?"/reply"
            render turbo_stream: turbo_stream.replace("comments_#{new_comment.parent_id}",
                                                      partial: 'shared/comment',
                                                      locals: { micropost: @micropost })
          else
            render turbo_stream: turbo_stream.prepend("microposts_#{@micropost.id}",
                                                      partial: 'shared/comment',
                                                      locals: { micropost: new_comment })
          end
        }
        format.html { redirect_to @micropost, status: :created }
      else
        format.html { redirect_to @micropost, status: :unprocessable_entity }
      end
    end
  end

  private
  def comment_params
    params.require(:micropost).permit(:content)
  end
end
