class CreateBalances < ActiveRecord::Migration[6.0]
  def change
    create_table :balances do |t|
      t.references :transaction, null: false, foreign_key: true
      t.decimal :debit, precision: 9, scale: 2
      t.decimal :credit, precision: 10, scale: 2

      t.timestamps
    end
  end
end
