class Balance < ApplicationRecord
  # belongs_to :transaction
  belongs_to :trsc, class_name: 'Transaction', foreign_key: 'transaction_id'
end
