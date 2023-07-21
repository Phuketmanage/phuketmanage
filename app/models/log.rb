class Log < ApplicationRecord
  # t.string "user_email" (user email)
  # t.jsonb "user_roles" (user roles)
  # t.string "location" (controller#action)
  # t.string "model_gid"(model gid)
  # t.jsonb "before" (full model before)
  # t.jsonb "applied_changes"(new changes)

validates :user_email, :user_roles, :location, :model_gid, :before, :applied_changes, presence: true

end
