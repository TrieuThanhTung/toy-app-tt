class StaticPagesController < ApplicationController
  def test
    render json: {
      Hahah: "oke"
    }
  end

  def home
    @micropost = current_user.microposts.build if logged_in?
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
