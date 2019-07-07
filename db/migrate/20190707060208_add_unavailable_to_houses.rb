class AddUnavailableToHouses < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :unavailable, :boolean, default: false
    add_index :houses, :unavailable
  end
end
