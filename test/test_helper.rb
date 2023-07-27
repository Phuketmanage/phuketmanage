require 'simplecov'

ENV['RAILS_ENV'] ||= 'test'
ENV['S3_BUCKET'] = 'phuketmanage-development'
ENV['AWS_ACCESS_KEY_ID'] = 'AKIASANYCWRAMOW5GHMY'
ENV['AWS_SECRET_ACCESS_KEY'] = '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'

require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    parallelize_setup do |worker|
      # Set simplecov command name
      SimpleCov.command_name "Minitest-#{worker}"
    end

    parallelize_teardown do |_worker|
      # Cleanup databases
      ActiveRecord::Base.connection.begin_transaction
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table} CASCADE")
      end
      ActiveRecord::Base.connection.commit_transaction

      # Generate simplecov report
      SimpleCov.result
    end

    # Run tests in parallel
    parallelize(workers: 4)

    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  module Integration
    class Session
      def default_url_options
        { locale: I18n.locale }
      end
    end
  end
end
