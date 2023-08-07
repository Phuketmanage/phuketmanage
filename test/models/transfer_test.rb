# == Schema Information
#
# Table name: transfers
#
#  id         :bigint           not null, primary key
#  booked_by  :string
#  client     :string
#  date       :date
#  from       :string
#  number     :string
#  pax        :string
#  remarks    :string
#  status     :integer
#  time       :string
#  to         :string
#  trsf_type  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  booking_id :bigint
#
# Indexes
#
#  index_transfers_on_booking_id  (booking_id)
#  index_transfers_on_number      (number)
#
# Foreign Keys
#
#  fk_rails_...  (booking_id => bookings.id)
#
require 'test_helper'

class TransferTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
