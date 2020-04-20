class CreateTransactionFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_files do |t|
      t.references :trsc, null: false, foreign_key: {to_table: :transactions}
      t.string :url, null: false

      t.timestamps
    end
  end
end
