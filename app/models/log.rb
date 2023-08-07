class Log < ApplicationRecord
  validates :user_email, :user_roles, :location, :model_gid, :before_values, :applied_changes, presence: true
end
