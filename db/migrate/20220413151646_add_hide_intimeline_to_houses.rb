class AddHideIntimelineToHouses < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :hide_in_timeline, :boolean, null: false, default: false
  end
end
