class CreateTransactionTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_types do |t|
      t.string :name_en
      t.string :name_ru
      t.boolean :debit_company
      t.boolean :credit_company
      t.boolean :debit_owner
      t.boolean :credit_owner

      t.timestamps
    end
  end
end
