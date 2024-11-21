class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  around_action :set_sentry_context
  allow_browser versions: :modern
  include SessionsHelper


  private
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def set_sentry_context
    begin
      yield
    rescue StandardError => e
      sentry = Sentry.capture_exception(e)
      SentryService.new(sentry.event_id, e).report
      raise e
    end
  end
end
