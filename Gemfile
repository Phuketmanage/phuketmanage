# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem "rails", "~> 7.0.6"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.3"
# Use Puma as the app server
gem "puma", "~> 6"
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'

gem "turbo-rails", "~> 1.4.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis'
# Use ActiveModel has_secure_password
# gem 'bcrypt'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.6.0'
gem 'bootstrap-select-rails'
gem 'cancancan'
gem 'devise'
gem 'devise_invitable', '~> 2.0.0'
gem 'flag-icons-rails'
gem 'http_accept_language'
gem 'icalendar', '~> 2.7', '>= 2.7.1'
gem 'jquery-rails'
# gem 'aws-sdk', '~> 3.0', '>= 3.0.1'
gem 'aws-sdk-s3', '~> 1.0.0.rc2'
gem 'barnes'
gem 'font_awesome5_rails'
gem 'momentjs-rails'
gem 'rails-i18n', '~> 7.0.0'
gem 'scout_apm'
gem 'the_schema_is'
gem 'twilio-ruby'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'dotenv-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'chusaku', '~> 0.6.1' # annotations for routes
  gem "letter_opener", "~> 1.8"
  gem 'rails-erd'
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd'
  # Shows better errors description and webconsole directly on errors page
  gem "better_errors", "~> 2.9.0"
  gem "binding_of_caller"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'faker'
  gem 'simplecov'
  gem 'shoulda-matchers', '~> 5.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'webrick', '~> 1.7'

gem "terser", "~> 1.1"

gem "jsbundling-rails", "~> 1.1"
