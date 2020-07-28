class AddMeterReadingToHouse < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :water_reading, :boolean, default: false
  end
end
