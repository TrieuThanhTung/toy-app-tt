Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/0') }
  config.on(:startup) do
    if (schedules = YAML.load_file(Rails.root.join('config/schedule.yml'))[:schedule])
      Sidekiq.schedule = schedules
      SidekiqScheduler::Scheduler.instance.reload_schedule!
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/0') }
end
