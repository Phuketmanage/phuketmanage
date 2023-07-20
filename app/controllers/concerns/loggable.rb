# frozen_string_literal: true

## Method to log events inside controller. Automaticly logs user, controller and action name, subject model GID,
# subject before state and applyed changes
#
## Accepts:
# subject - model instance object
#
## Usage
#
# 1. Enable global usage in settings ['user_activity_logging'] == 'true'
#
# 2. Add in controller:
# include Loggable
#
# 3. When you want to log action, wrap it inside a transaction and after update call log_event(subject):
# ActiveRecord::Base.transaction do
#   price.update(price_params)
#   log_event(price)
# end
#
module Loggable
  extend ActiveSupport::Concern

  included do
    def log_event(subject)
      return true unless loggin_enabled?

      track_changes(subject)
      Log.add(user_email: actor_email, user_roles: actor_roles, location: action_location,
              model_gid: subject.to_global_id, before: @past_values, applied_changes: @new_values)
    end

    private

    def loggin_enabled?
      @settings['user_activity_logging'] == 'true'
    end

    def actor_email
      if current_user
        current_user.email
      else
        'Unauthorized'
      end
    end

    def actor_roles
      if current_user
        roles = []
        current_user.roles.each do |role|
          roles << role.name
        end
        roles
      else
        'Unauthorized'
      end
    end

    def action_location
      "#{controller_name}##{action_name}"
    end

    def track_changes(subject)
      input_hash = subject.previous_changes

      @past_values = subject.as_json
      @new_values = {}

      return unless input_hash.any?

      input_hash.each do |key, values|
        @past_values[key] = values[0]
        @new_values[key] = values[1]
      end
    end
  end
end
