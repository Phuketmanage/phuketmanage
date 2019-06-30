class CreatePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.references :house, null: false, foreign_key: true
      t.integer :season_id
      t.integer :duration_id
      t.integer :amount

      t.timestamps
    end
    add_index :prices, :season_id
    add_index :prices, :duration_id
  end
end
