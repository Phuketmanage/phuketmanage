# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    client_details { Faker::Name.last_name }
    sale { Random.rand(10..90) * 1000 }
    agent { (sale * [0, 0.1].sample).to_i }
    comm { (sale * 0.02).to_i - agent }
    nett { sale - agent - comm }
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
