
class StaticPagesController < ApplicationController
  def test
    # send_mail_job = SendMailJob.perform_later current_user
    first_user = User.first.as_json
    RedisService.set("first_user", first_user)
    RedisService.delete("first_user")
    render json: {"test": {get: RedisService.get("first_user").to_json, exists: !RedisService.exists?("first_user").zero? } }
  end
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
