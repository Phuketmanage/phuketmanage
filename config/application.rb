require_relative "boot"
require "logger"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Phuketmanage
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Adds data: { remote: true } to all generated forms (default setting before Rails 6). Used by old forms submiting JS.
    #
    # TODO: #268 Mail to manager about new booking - link should open list with bookings for house
    config.action_view.form_with_generates_remote_forms = true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Bangkok"
    # config.eager_load_paths << Rails.root.join("extras")
    unless Rails.env.production?
      config.before_configuration do
        env_file = Rails.root.join("config/env_var.yml").to_s

        if File.exist?(env_file)
          YAML.load_file(env_file).each do |key, value|
            ENV[key.to_s] = value
          end # end YAML.load_file
        end # end if File.exists?
      end # end config.before_configuration
    end

    # Redirect errors to errors controller
    config.exceptions_app = routes

    # Active Storage
    config.active_storage.variant_processor = :vips
    config.active_storage.routes_prefix = 'files'
  end
end
