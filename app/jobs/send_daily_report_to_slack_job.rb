class SendDailyReportToSlackJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info "Sending daily report:\n"
    SlackReportService.new.daily_report
  end
end
