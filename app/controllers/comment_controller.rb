class CommentController < ApplicationController
  def index
    @comments = Comment.find_by!(micropost_id: params[:micropost_id])
    render json: @comments
  end
end
