class AddServiceFieldsToHouses < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :rental, :boolean, default: false
    add_column :houses, :maintenance, :boolean, default: false
    add_column :houses, :outsource_cleaning, :boolean, default: false
    add_column :houses, :outsource_linen, :boolean, default: false
  end
end
