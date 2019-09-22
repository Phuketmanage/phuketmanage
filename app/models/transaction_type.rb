class TransactionType < ApplicationRecord
  has_many :transactions, dependent: :nullify, foreign_key: 'type_id'
end
