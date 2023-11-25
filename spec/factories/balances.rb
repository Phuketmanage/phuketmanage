# == Schema Information
#
# Table name: balances
#
#  id             :bigint           not null, primary key
#  credit         :decimal(10, 2)
#  debit          :decimal(9, 2)
#  ref_no         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :bigint           not null
#
# Indexes
#
#  index_balances_on_transaction_id  (transaction_id)
#
# Foreign Keys
#
#  fk_rails_...  (transaction_id => transactions.id)
#
FactoryBot.define do
  factory :balance do
    ref_no { "Ref123456" }
    trsc { transaction }
  end
end
