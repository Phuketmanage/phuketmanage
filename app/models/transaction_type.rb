class TransactionType < ApplicationRecord
  the_schema_is "transaction_types" do |t|
    t.string "name_en"
    t.string "name_ru"
    t.boolean "debit_company"
    t.boolean "credit_company"
    t.boolean "debit_owner"
    t.boolean "credit_owner"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin_only", default: false
  end

  has_many :transactions, dependent: :nullify, foreign_key: 'type_id'
end
