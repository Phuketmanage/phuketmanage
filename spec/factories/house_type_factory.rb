FactoryBot.define do
  factory :house_type do
    name_en { Faker::Address.community }
    name_ru { Faker::Address.community }
    comm { Faker::Number.number(digits: 3) }
  end
end
