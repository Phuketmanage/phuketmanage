class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :ref_no
      t.references :house, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: {to_table: :transaction_types}
      t.references :user, null: false, foreign_key: true
      t.string :comment_en
      t.string :comment_ru
      t.string :comment_inner

      t.timestamps
    end
  end
end
