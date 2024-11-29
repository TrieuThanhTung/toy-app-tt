
class StaticPagesController < ApplicationController
  def test
    UserMailer.account_activation(current_user).deliver
    render json: {"test": "Hello World!" }
  end
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
