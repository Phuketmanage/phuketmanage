require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Phuketmanage
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    if Rails.env.development?
      config.before_configuration do
        env_file = Rails.root.join("config", 'env_var.yml').to_s

        if File.exists?(env_file)
          YAML.load_file(env_file).each do |key, value|
            ENV[key.to_s] = value
          end # end YAML.load_file
        end # end if File.exists?
      end # end config.before_configuration
    end
  end
end
