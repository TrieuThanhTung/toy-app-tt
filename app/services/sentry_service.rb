class SentryService
  include SlackReport
  def initialize(event_id, exception)
    @event_id = event_id
    @exception = exception
    @slack_report = SlackReportService.new
  end

  def report
    @slack_report.report(log_errors)
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
    end
  end

end
