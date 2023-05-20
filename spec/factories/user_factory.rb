FactoryBot.define do
  factory :user do
    email { Faker::Internet.email } 
    password {"qweasd"}
    trait :admin do
      roles { [create(:role, :admin)] }
    end
    trait :manager do
      roles { [create(:role, :manager)] }
    end
    trait :accounting do
      roles { [create(:role, :acounting)] }
    end
    trait :owner do
      roles { [create(:role, :owner)] }
    end
    trait :client do
      roles { [create(:role, :client)] }
    end
  end
end