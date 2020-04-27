class AddIndexToHouse < ActiveRecord::Migration[6.0]
  def change
    add_reference :houses, :house_group, null: true, foreign_key: true
  end
end
