namespace :slack_report do
  desc "Generate and send the Slack report"
  task report: :environment do
    SlackReportService.new.report
  end
end