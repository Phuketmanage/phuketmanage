FactoryBot.define do
  factory :house do
    number = Random.rand(1..100)
    description_en { "House#{number}" }
    description_ru { "House#{number}" }
    code { "HS#{Random.rand(1..10)}" }
    rooms { "#{Random.rand(1..4)}" }
    bathrooms { "#{Random.rand(1..3)}"}
    number { "#{(('1'..'9').to_a).shuffle[0..rand(1..6)].join}" }
    address { Faker::Address.full_address }
  end
end