require 'simplecov'
SimpleCov.start "rails"

ENV['RAILS_ENV'] ||= 'test'
ENV['S3_BUCKET'] = 'phuketmanage-development'
ENV['AWS_ACCESS_KEY_ID'] = 'AKIASANYCWRAMOW5GHMY'
ENV['AWS_SECRET_ACCESS_KEY'] = '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'

require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Parallel Testing with Processes
  parallelize(workers: 4)
end

module ActionDispatch::Integration
  class Session
    def default_url_options
      { locale: I18n.locale }
    end
  end
end
