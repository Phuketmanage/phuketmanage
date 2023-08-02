# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# System
gem 'aws-sdk-s3', '~> 1.0.0.rc2'
gem 'bootsnap', '>= 1.1.0', require: false # Reduces boot times through caching; required in config/boot.rb
gem "pg", "~> 1.3"
gem "puma", "~> 6"
gem "rails", "~> 7.0.6"
gem 'sassc-rails' # Use SCSS for stylesheets
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webrick', require: false

# App
gem 'barnes'
gem 'bootstrap', '~> 4.6.0'
gem 'bootstrap-select-rails'
gem 'cancancan'
gem 'coffee-rails' # Use CoffeeScript for .coffee assets and views
gem 'devise'
gem 'devise_invitable', '~> 2.0.0'
gem 'flag-icons-rails'
gem 'font_awesome5_rails'
gem 'http_accept_language'
gem 'icalendar', '~> 2.7', '>= 2.7.1'
gem 'jbuilder' # Build JSON APIs with ease.
gem 'jquery-rails'
gem "jsbundling-rails", "~> 1.1"
gem 'momentjs-rails'
gem 'rails-i18n', '~> 7.0.0'
gem 'stimulus-rails'
gem "terser", "~> 1.1"
gem 'the_schema_is'
gem "turbo-rails", "~> 1.4.0"
gem 'twilio-ruby'
gem 'easy_translate'
gem "ranked-model", "~> 0.4.8"
gem "requestjs-rails", "~> 0.0.10"
gem 'newrelic_rpm'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'faker'
  gem 'brakeman'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "better_errors", "~> 2.9.0" # Shows better errors description on errors page
  gem "binding_of_caller" # For better errors: activates webconsole directly in browser
  gem 'chusaku', require: false # annotations for routes
  gem "letter_opener", "~> 1.8"
  gem 'rails-erd'
  gem "rubocop-minitest"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'timecop'
  gem "webmock"
end
