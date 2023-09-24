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
