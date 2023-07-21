require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Phuketmanage
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    if !Rails.env.production?
      config.before_configuration do
        env_file = Rails.root.join("config", 'env_var.yml').to_s

        if File.exist?(env_file)
          YAML.load_file(env_file).each do |key, value|
            ENV[key.to_s] = value
          end # end YAML.load_file
        end # end if File.exists?
      end # end config.before_configuration
    end
  end
end
