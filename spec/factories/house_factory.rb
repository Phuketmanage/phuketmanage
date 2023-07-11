# frozen_string_literal: true

FactoryBot.define do
  factory :house do
    sequence(:number) { |n| 100_000 + n }
    sequence(:description_en) { |n| "House#{100_000 + n}" }
    sequence(:description_ru) { |n| "Вилла#{100_000 + n}" }
    sequence(:code) { |n| "HS#{100_000 + n}" }
    rooms { Random.rand(1..4) }
    bathrooms { Random.rand(1..3) }
    address { Faker::Address.full_address }
    owner { build :user }
    type { build :house_type }
    project { Faker::Address.city }
  end
end
