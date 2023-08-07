# == Schema Information
#
# Table name: jobs
#
#  id             :bigint           not null, primary key
#  before         :string
#  closed         :date
#  collected      :date
#  comment        :text
#  job            :text
#  paid_by_tenant :boolean          default(FALSE), not null
#  plan           :date
#  price          :integer
#  rooms          :integer
#  sent           :date
#  status         :integer          default("inbox")
#  time           :string
#  urgent         :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  booking_id     :bigint
#  creator_id     :bigint           not null
#  employee_id    :bigint
#  house_id       :bigint
#  job_type_id    :bigint           not null
#  user_id        :bigint
#
# Indexes
#
#  index_jobs_on_booking_id   (booking_id)
#  index_jobs_on_creator_id   (creator_id)
#  index_jobs_on_employee_id  (employee_id)
#  index_jobs_on_house_id     (house_id)
#  index_jobs_on_job_type_id  (job_type_id)
#  index_jobs_on_status       (status)
#  index_jobs_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (booking_id => bookings.id)
#  fk_rails_...  (creator_id => users.id)
#  fk_rails_...  (employee_id => employees.id)
#  fk_rails_...  (house_id => houses.id)
#  fk_rails_...  (job_type_id => job_types.id)
#  fk_rails_...  (user_id => users.id)
#
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
