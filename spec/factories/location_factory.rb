# frozen_string_literal: true

FactoryBot.define do
  factory :location do
    name_en { Faker::Address.city }
  end
end
