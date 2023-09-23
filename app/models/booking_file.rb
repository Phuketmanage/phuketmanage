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
# TODO: remove url field in #353
class BookingFile < ApplicationRecord
  include OrderableByTimestamp

  belongs_to :booking
  belongs_to :user, optional: true

  has_one_attached :data, dependent: :purge_later

  validates :data, presence: true
end
