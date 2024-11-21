class SentryService
  include SlackReport
  def initialize(event_id, exception)
    @event_id = event_id
    @exception = exception
    @slack_report = SlackReportService.new
  end

  def report
    begin
      @slack_report.report(log_errors)
    rescue StandardError => e
      Rails.logger.error(e)
      Sentry.capture_exception(e)
    end
  end

  private
  def log_errors
    [
      header_section("Log Errors: #{@event_id}"),
      divider,
      info_section("Errors: #{@exception.class} - #{@exception.message}"),
      info_section("Timestamp: #{DateTime.now}"),
      info_section(sentry_log_link),
      divider
    ]
  end

  def sentry_log_link
    if ENV["SENTRY_EVENT"]
      "Details: #{ENV["SENTRY_EVENT"]}/#{@event_id}"
    else
      "Cannot get link to Sentry"
    end
  end
end
