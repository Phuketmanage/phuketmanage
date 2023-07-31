# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    client_details { Faker::Name.last_name }
    sale { 1000 }
    agent { 0 }
    comm { 0 }
    nett { 1000 }
    allotment { false }
    trait :pending do
      status { "pending" }
    end
    trait :confirmed do
      status { "confirmed" }
    end
    trait :canceled do
      status { "canceled" }
    end
  end
end
