# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    client_details { Faker::Name.last_name }
    sale { 0 }
    agent { 0 }
    comm { 0 }
    nett { 0 }
  end
end
