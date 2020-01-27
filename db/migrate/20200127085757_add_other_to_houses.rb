class AddOtherToHouses < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :other_ru, :text
    add_column :houses, :other_en, :text
  end
end
