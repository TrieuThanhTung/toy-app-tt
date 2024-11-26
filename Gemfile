source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.1"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire"s modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"
gem "slack-notifier", "~> 2.4"

gem "jquery-rails"
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
gem "bootstrap-sass", "~> 3.4", ">= 3.4.1"
gem "stimulus-rails"

gem "bcrypt", "~> 3.1", ">= 3.1.20"
gem "faker", "~> 3.4", ">= 3.4.2"
gem "dotenv-rails", "~> 3.1", ">= 3.1.4"
gem "rails-controller-testing", "~> 1.0", ">= 1.0.5"

gem "will_paginate", "~> 4.0", ">= 4.0.1"
gem "will_paginate-bootstrap4"
gem "active_storage_validations", "~> 1.1", ">= 1.1.4"
gem "image_processing", "1.9.3"
gem "mini_magick", "~> 4.11", ">= 4.11.0"
gem "whenever", require: false

gem "stackprof"
gem "sentry-ruby"
gem "sentry-rails"

gem "devise"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "omniauth-github", "~> 1.1", ">= 1.1.2"
gem "omniauth-facebook"
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
gem "reek", "~> 6.3"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "factory_bot_rails"
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  gem "rspec-rails", "~> 7.0.0"
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Highlight the fine-grained location where an error occurred [https://github.com/ruby/error_highlight]
  gem "error_highlight", "~> 0.3.0", platforms: [ :ruby ]
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 6.0"
end
