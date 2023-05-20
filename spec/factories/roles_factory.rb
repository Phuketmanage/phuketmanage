FactoryBot.define do
  factory :role do
    trait :admin do
      name { "Admin" }
    end
    trait :manager do
      name { "Manager" }
    end
    trait :acounting do
      name { "Accounting" }
    end
    trait :owner do
      name { "Owner" }
    end
    trait :client do
      name { "Client" }
    end
  end
end