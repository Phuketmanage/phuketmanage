class AddFieldsToHouses < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :code, :string
    add_column :houses, :size, :integer
    add_column :houses, :plot_size, :integer
    add_column :houses, :rooms, :integer
    add_column :houses, :bathrooms, :integer
    add_column :houses, :pool, :boolean
    add_column :houses, :pool_size, :string
    add_column :houses, :communal_pool, :boolean
    add_column :houses, :parking, :boolean
    add_column :houses, :parking_size, :integer

    add_index :houses, :code
    add_index :houses, :rooms
    add_index :houses, :bathrooms
    add_index :houses, :communal_pool
    add_index :houses, :parking
  end
end
