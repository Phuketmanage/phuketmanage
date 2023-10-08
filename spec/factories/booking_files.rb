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
FactoryBot.define do
  factory :booking_file do
    comment { Faker::Lorem.sentence }
    name { Faker::Lorem.word }

    booking
    user

    after(:build) do |booking_file|
      booking_file.data.attach(io: File.open('spec/support/files/document.jpeg'), filename: 'document.jpeg',
                               content_type: 'image/jpeg')
    end
  end
end
