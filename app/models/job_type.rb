# == Schema Information
#
# Table name: job_types
#
#  id             :bigint           not null, primary key
#  code           :string
#  color          :string
#  for_house_only :boolean
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class JobType < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_and_belongs_to_many :empl_types
end
