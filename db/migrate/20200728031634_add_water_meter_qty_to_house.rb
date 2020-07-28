class AddWaterMeterQtyToHouse < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :water_meters, :integer, default: 1
  end
end
