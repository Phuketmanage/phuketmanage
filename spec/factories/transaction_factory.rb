FactoryBot.define do
  factory :transaction do
    comment_en { "Test comment" }
    house
    date { DateTime.now }
    type factory: %i[transaction_type maintenance]
  end
end
