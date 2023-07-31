# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    client_details { Faker::Name.last_name }
    sale { Random.rand(1..3) * 1000 }
    agent { Random.rand(0..5) * 100 }
    comm { Random.rand(1..6) * 100 }
    nett { sale - agent - comm }
    allotment { false }
  end
end
