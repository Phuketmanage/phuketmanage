# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    amount { Random.rand(1..3) * 1000 }
  end
end
