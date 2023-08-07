# frozen_string_literal: true

Faker::Config.locale = :en

FactoryBot.define do
  factory :location do
    name_en { Faker::Address.city }
  end
end
