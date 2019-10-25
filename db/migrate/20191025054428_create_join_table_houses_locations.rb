class CreateJoinTableHousesLocations < ActiveRecord::Migration[6.0]
  def change
    create_join_table :houses, :locations do |t|
      t.index [:house_id, :location_id]
      # t.index [:location_id, :house_id]
    end
  end
end
