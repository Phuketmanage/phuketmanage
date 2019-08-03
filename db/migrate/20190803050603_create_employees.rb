class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.references :type, null: false, foreign_key: {to_table: :empl_types}
      t.string :name

      t.timestamps
    end
  end
end
