# == Schema Information
#
# Table name: booking_files
#
#  id         :bigint           not null, primary key
#  comment    :text
#  name       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  booking_id :bigint           not null
#  user_id    :bigint
#
# Indexes
#
#  index_booking_files_on_booking_id  (booking_id)
#  index_booking_files_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (booking_id => bookings.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class BookingFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
