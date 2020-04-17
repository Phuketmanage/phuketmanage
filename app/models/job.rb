class Job < ApplicationRecord
  enum status: {  inbox: 0, in_progress: 1, done: 2, paused: 3,
                  cancelled: 4, archived: 5 }

  belongs_to :job_type
  belongs_to :user, optional: true
  belongs_to :creator, class_name: 'User'
  belongs_to :booking, optional: true
  belongs_to :house, optional: true
  belongs_to :employee, optional: true
  has_many :job_messages, dependent: :destroy
  has_many :job_tracks, dependent: :destroy
  # validates :plan, presence: true

end
