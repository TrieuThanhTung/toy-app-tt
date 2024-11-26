env :PATH, ENV["PATH"]

set :environment, "development"
set :output, "./log/cron_log.log"

every 1.day, at: "8:00am" do
  rake "slack_report:report"
end
