# == Schema Information
#
# Table name: logs
#
#  id              :bigint           not null, primary key
#  applied_changes :jsonb
#  before_values   :jsonb
#  location        :string
#  model_gid       :string
#  user_email      :string
#  user_roles      :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Log < ApplicationRecord
  validates :user_email, :user_roles, :location, :model_gid, :before_values, :applied_changes, presence: true
end
