
class StaticPagesController < ApplicationController
  def test
    SlackReportService.new.report

    render json: {
      Hahah: "oke"
    }
  end

  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end
