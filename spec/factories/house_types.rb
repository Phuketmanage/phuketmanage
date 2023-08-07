# frozen_string_literal: true

# == Schema Information
#
# Table name: house_types
#
#  id         :bigint           not null, primary key
#  comm       :integer
#  name_en    :string
#  name_ru    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
