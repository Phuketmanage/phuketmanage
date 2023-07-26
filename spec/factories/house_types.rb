# frozen_string_literal: true

FactoryBot.define do
  factory :house_type do
    name_en { "House" }
    name_ru { "Дом" }
    comm { Faker::Number.number(digits: 3) }

    trait :villa do
      name_en { "Villa" }
      name_ru { "Вилла" }
    end

    trait :townhouse do
      name_en { "Townhouse" }
      name_ru { "Таунхаус" }
    end

    trait :appartment do
      name_en { "Appartment" }
      name_ru { "Апартаменты" }
    end
  end
end
