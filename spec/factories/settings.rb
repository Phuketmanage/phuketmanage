# frozen_string_literal: true

FactoryBot.define do
  factory :setting do
    trait :dtnb do
      var { "dtnb" }
      value { 1 }
      description { "How many days till next booking" }
    end

    trait :tranfer_supplier_email do
      var { "tranfer_supplier_email" }
      value { "bytheair@gmail.com" }
      description { "tranfer supplier email" }
    end

    trait :usd_rate do
      var { "usd_rate" }
      value { 33 }
      description { "usd rate" }
    end

    trait :user_activity_logging_enabled do
      var { "user_activity_logging_enabled" }
      description { "Enable users activity logging." }
    end
  end
end
