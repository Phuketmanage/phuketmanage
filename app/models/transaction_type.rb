# == Schema Information
#
# Table name: transaction_types
#
#  id             :bigint           not null, primary key
#  admin_only     :boolean          default(FALSE)
#  credit_company :boolean
#  credit_owner   :boolean
#  debit_company  :boolean
#  debit_owner    :boolean
#  name_en        :string
#  name_ru        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class TransactionType < ApplicationRecord
  has_many :transactions, dependent: :nullify, foreign_key: 'type_id'
end
