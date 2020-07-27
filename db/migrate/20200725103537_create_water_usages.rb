class CreateWaterUsages < ActiveRecord::Migration[6.0]
  def change
    create_table :water_usages do |t|
      t.references :house, null: false, foreign_key: true
      t.date :date
      t.integer :amount

      t.timestamps
    end
  end
end
