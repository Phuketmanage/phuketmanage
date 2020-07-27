class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :level
      t.string :text
      t.references :house, null: false, foreign_key: true

      t.timestamps
    end
  end
end
