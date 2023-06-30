FactoryBot.define do
  factory :house_type do
    trait :villa do
      name_en { "Villa" }
      name_ru { "Вилла" }
    end
    trait :townhouse do
      name_en { "Townhouse" }
      name_ru { "Таунхаус" }
    end
    trait :appartment do
      name_en { "Appartment" }
      name_ru { "Апартаменты" }
    end
  end
end