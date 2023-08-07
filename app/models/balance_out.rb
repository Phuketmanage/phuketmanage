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
class BalanceOut < ApplicationRecord
  # belongs_to :transaction
  belongs_to :trsc, class_name: 'Transaction', foreign_key: 'transaction_id'
end
