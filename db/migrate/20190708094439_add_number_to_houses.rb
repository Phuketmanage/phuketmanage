class AddNumberToHouses < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :number, :string, limit: 10
    add_index :houses, :number, unique: true
  end
end
