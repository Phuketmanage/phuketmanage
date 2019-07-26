class Job < ApplicationRecord
  belongs_to :job_type
  belongs_to :user, optional: true
  belongs_to :creator, class_name: 'User'
  belongs_to :booking, optional: true
  belongs_to :house, optional: true
  validates :plan, presence: true
end
