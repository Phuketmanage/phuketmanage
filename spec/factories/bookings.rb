# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    client_details { Faker::Name.last_name }
    sale { 1000 }
    agent { 0 }
    comm { 0 }
    nett { 1000 }
    allotment { false }
  end
end
