class CreateDurations < ActiveRecord::Migration[6.0]
  def change
    create_table :durations do |t|
      t.integer :start
      t.integer :finish
      t.references :house, null: false, foreign_key: true

      t.timestamps
    end
  end
end
