FactoryBot.define do
  factory :user do
    email { Faker::Internet.email } 
    password {"qweasd"}
    trait :admin do
      roles { [Role.find_or_create_by(name: 'Admin')] }
    end
    trait :manager do
      roles { [Role.find_or_create_by(name: 'Manager')] }
    end
    trait :accounting do
      roles { [Role.find_or_create_by(name: 'Accounting')] }
    end
    trait :owner do
      roles { [Role.find_or_create_by(name: 'Owner')] }
    end
    trait :client do
      roles { [Role.find_or_create_by(name: 'Client')] }
    end
  end
end