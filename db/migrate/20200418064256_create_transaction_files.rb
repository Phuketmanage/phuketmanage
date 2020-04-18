class CreateTransactionFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_files do |t|
      t.references :transaction, null: false, foreign_key: true
      t.string :url, null: false

      t.timestamps
    end
  end
end
