# == Schema Information
#
# Table name: balance_outs
#
#  id             :bigint           not null, primary key
#  credit         :decimal(10, 2)
#  debit          :decimal(9, 2)
#  ref_no         :string
#  ref_no_iv      :string
#  ref_no_re      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  transaction_id :bigint           not null
#
# Indexes
#
#  index_balance_outs_on_transaction_id  (transaction_id)
#
# Foreign Keys
#
#  fk_rails_...  (transaction_id => transactions.id)
#
FactoryBot.define do
  factory :balance_out do
    association :trsc, factory: :transaction
  end
end
