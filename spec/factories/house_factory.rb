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
    owner { build :user, :owner }
    type { build :house_type }
    project { Faker::Address.city }
    unavailable { false }
    after(:create) do |house|
      create_list :duration, 1, house: house
    end
    trait :with_seasons do
      after(:create) do |house|
        create(:season, ssd: 15, ssm: 4, sfd: 1, sfm: 11, house: house)
        create(:season, ssd: 1, ssm: 11, sfd: 1, sfm: 12, house: house)
        create(:season, ssd: 1, ssm: 12, sfd: 15, sfm: 12, house: house)
        create(:season, ssd: 15, ssm: 12, sfd: 15, sfm: 1, house: house)
        create(:season, ssd: 15, ssm: 1, sfd: 1, sfm: 3, house: house)
        create(:season, ssd: 1, ssm: 3, sfd: 15, sfm: 4, house: house)
        # Creating prices for every season
        house.seasons.map{|season| create(:price, house: house, season: season, duration: house.durations.first) }
      end
    end
  end
end
