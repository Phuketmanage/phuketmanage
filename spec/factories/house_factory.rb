FactoryBot.define do
  factory :house do
    desc = Random.rand(1..10)
    description_en { "House#{desc}" }
    description_ru { "House#{desc}" }
    code { "HS#{desc}" }
    rooms { "#{Random.rand(1..4)}" }
    bathrooms { "#{Random.rand(1..3)}"}
    number { "#{(('1'..'9').to_a).shuffle[0..rand(1..6)].join}" }
    address { Faker::Address.full_address }
  end
end