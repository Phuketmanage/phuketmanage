FactoryBot.define do
  factory :balance_out do
    association :trsc, factory: :transaction
  end
end
