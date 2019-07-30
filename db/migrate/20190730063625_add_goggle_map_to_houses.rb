class AddGoggleMapToHouses < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :google_map, :string
  end
end
