class CreateTodos < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :user, null: false, foreign_key: true
      t.date :plan
      t.date :closed
      t.text :job
      t.text :comment

      t.timestamps
    end
  end
end
