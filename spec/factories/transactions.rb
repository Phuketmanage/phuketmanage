# == Schema Information
#
# Table name: transactions
#
#  id            :bigint           not null, primary key
#  cash          :boolean          default(FALSE), not null
#  comment_en    :string
#  comment_inner :string
#  comment_ru    :string
#  date          :date
#  deleted       :boolean          default(FALSE), not null
#  for_acc       :boolean          default(FALSE)
#  hidden        :boolean          default(FALSE)
#  incomplite    :boolean          default(FALSE), not null
#  ref_no        :string
#  transfer      :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  booking_id    :bigint
#  house_id      :bigint
#  type_id       :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_transactions_on_booking_id  (booking_id)
#  index_transactions_on_house_id    (house_id)
#  index_transactions_on_type_id     (type_id)
#  index_transactions_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (booking_id => bookings.id)
#  fk_rails_...  (house_id => houses.id)
#  fk_rails_...  (type_id => transaction_types.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :transaction do
    comment_en { "Test comment" }
    house
    date { DateTime.current }
    type factory: %i[transaction_type maintenance]
  end
end
