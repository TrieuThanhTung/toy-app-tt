
class StaticPagesController < ApplicationController
  def test
    send_mail_job = SendMailJob.perform_later current_user
    # UserMailer.account_activation(current_user).deliver_now
    render json: {"test": "Hello World!" }
  end
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
