# frozen_string_literal: true

FactoryBot.define do
  factory :transction_type do
    trait :improvements do
      name_en { "Improvements" }
      name_ru { "Улучшения" }
    end
    trait :rental do
      name_en { "Rental" }
      name_ru { "Аренда" }
    end
    trait :maintenance do
      name_en { "Maintenance" }
      name_ru { "Обслуживание" }
    end
    trait :top_up do
      name_en { "Top up" }
      name_ru { "Пополнение баланса" }
    end
    trait :repair do
      name_en { "Repair" }
      name_ru { "Ремонт" }
    end
    trait :laundry do
      name_en { "Laundry" }
      name_ru { "Стирка" }
    end
    trait :utilities do
      name_en { "Utilities" }
      name_ru { "Ком платежи" }
    end
    trait :insurance do
      name_en { "Insurance" }
      name_ru { "Страховка" }
    end
    trait :purchases do
      name_en { "Purchases" }
      name_ru { "Покупки" }
    end
    trait :salary do
      name_en { "Salary" }
      name_ru { "Зарплата" }
    end
    trait :office do
      name_en { "Office" }
      name_ru { "Офис" }
    end
    trait :suppliers do
      name_en { "Suppliers" }
      name_ru { "Подрядчики" }
    end
    trait :from_guests do
      name_en { "From guests" }
      name_ru { "Платежи с гостей" }
    end
    trait :to_owner do
      name_en { "To owner" }
      name_ru { "Владельцу" }
    end
    trait :common_area do
      name_en { "Common area" }
      name_ru { "Общая территория" }
    end
    trait :eqp_cons do
      name_en { "Eqp & Cons" }
      name_ru { "Оборудование и расходники" }
    end
    trait :transfer do
      name_en { "Transfer" }
      name_ru { "Перевод" }
    end
    trait :gasoline do
      name_en { "Gasoline" }
      name_ru { "Бензин" }
    end
    trait :consumables do
      name_en { "Consumables" }
      name_ru { "Расходники" }
    end
    trait :yearly_contracts do
      name_en { "Yearly contracts" }
      name_ru { "Годовые контракты" }
    end
    trait :materials do
      name_en { "Materials" }
      name_ru { "Материалы" }
    end
    trait :eqp_maintenance do
      name_en { "Eqp maintenance" }
      name_ru { "Обслуживание техники" }
    end
    trait :pest_controll do
      name_en { "Pest control" }
      name_ru { "Обработка от вредеилей" }
    end
    trait :other do
      name_en { "Other" }
      name_ru { "Другое" }
    end
  end
end
