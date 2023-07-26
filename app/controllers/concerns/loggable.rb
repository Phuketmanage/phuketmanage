# frozen_string_literal: true

## Method to log events inside controller. Automatically logs user, controller and action name, subject model GID,
# subject before state and applyed changes. If no changes were made during update, no log will be created.
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
# 1. Enable global usage in the settings, adding var: 'user_activity_logging_enabled'
#
# 2. Add in controller:
# include Loggable
#
# 3. When you want to log action, call log_event(subject) after update:
#
# if price.update(price_params)
#   log_event(price)
#   do_some_staff
# end
#
module Loggable
  extend ActiveSupport::Concern

  included do
    def log_event(subject)
      @subject = subject

      return true unless logging_enabled? && changes_applied?

      log = Log.new(user_email: actor_email, user_roles: actor_roles, location: action_location,
                    model_gid: subject_gid, before_values: previous_state, applied_changes: new_values)
      if log.save
        true
      else
        logger.error "Error logging action at #{action_location}. Reasons: #{log.errors.full_messages.join('; ')}"
        false
      end
    end

    private

    def logging_enabled?
      @settings.key?("user_activity_logging_enabled")
    end

    # Check for situation when update is done with no changed attributes
    def changes_applied?
      @subject.previous_changes.any?
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
        current_user.roles.pluck(:name).join(', ').presence || ["Unauthorized"]
      else
        ["Unauthorized"]
      end
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
