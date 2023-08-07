# == Schema Information
#
# Table name: job_tracks
#
#  id         :bigint           not null, primary key
#  visit_time :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  job_id     :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_job_tracks_on_job_id   (job_id)
#  index_job_tracks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class JobTrackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
