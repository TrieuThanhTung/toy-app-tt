
class StaticPagesController < ApplicationController
  def test
    SlackReportService.new.report
    redirect_to root_path
  end

  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
