class CreateLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :logs do |t|
      t.datetime :when
      t.references :user, null: false, foreign_key: true
      t.string :where
      t.text :before
      t.text :after

      t.timestamps
    end
  end
end
