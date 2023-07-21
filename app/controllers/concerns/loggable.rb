# frozen_string_literal: true

## Method to log events inside controller. Automaticly logs user, controller and action name, subject model GID,
# subject before state and applyed changes
#
## Accepts:
# subject - model instance object
#
## Returns:
# - True if the action was successful
# - False if action failed.
#
# If there was failure it sends error message to Rails error log.
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
      return true unless logging_enabled?

      @subject = subject

      transaction = Log.new(user_email: actor_email, user_roles: actor_roles, location: action_location,
                            model_gid: subject_gid, before: previous_state, applied_changes: new_values)
      if transaction.save
        true
      else
        logger.error { "Error logging action at #{action_location}. Reasons: #{transaction.errors.full_messages}" }
        false
      end
    end

    private

    def logging_enabled?
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
      current_user.roles.pluck(:name).join(', ').presence || ["Unauthorized"]
    end

    def action_location
      "#{controller_name}##{action_name}"
    end

    def new_values
      @subject.previous_changes.transform_values(&:last)
    end

    def old_values
      @subject.previous_changes.transform_values(&:first)
    end

    def previous_state
      @subject.as_json.merge(old_values)
    end

    def subject_gid
      @subject.to_global_id
    end
  end
end
