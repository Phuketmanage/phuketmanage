# == Schema Information
#
# Table name: job_messages
#
#  id         :bigint           not null, primary key
#  file       :boolean          default(FALSE)
#  is_system  :boolean
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  job_id     :bigint           not null
#  sender_id  :bigint           not null
#
# Indexes
#
#  index_job_messages_on_job_id     (job_id)
#  index_job_messages_on_sender_id  (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (sender_id => users.id)
#
require 'test_helper'

class JobMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
