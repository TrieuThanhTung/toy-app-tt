set :environment, "development"
set :output, "./log/cron_log.log"

every 1.day, at: '8:00am' do
  command "cd /home/teg/workspace/rails/projectsty/toy-app-tt
          && /home/teg/.rbenv/shims/bundle exec bin/rails runner SlackReportService.new.report"
end
