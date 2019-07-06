class AddColumnToHouses < ActiveRecord::Migration[6.0]
  def change
    add_reference :houses, :type, null: false, foreign_key: {to_table: :house_types}
  end
end
