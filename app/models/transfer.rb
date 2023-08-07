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
class Transfer < ApplicationRecord
  enum trsf_type: { IN: 0, OUT: 1 }
  enum status: { sent: 0, confirmed: 1, amended: 2, canceling: 3, canceled: 4 }

  belongs_to :booking, optional: :true
end
