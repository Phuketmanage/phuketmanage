class BalanceOut < ApplicationRecord
  the_schema_is "balance_outs" do |t|
    t.bigint "transaction_id", null: false
    t.decimal "debit", precision: 9, scale: 2
    t.decimal "credit", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ref_no_iv"
    t.string "ref_no_re"
    t.string "ref_no"
  end

  # belongs_to :transaction
  belongs_to :trsc, class_name: 'Transaction', foreign_key: 'transaction_id'
end
