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
require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
