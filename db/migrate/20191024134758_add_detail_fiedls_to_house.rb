class AddDetailFiedlsToHouse < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :capacity, :integer
    add_column :houses, :seaview, :boolean, default: false
    add_column :houses, :kingBed, :integer
    add_column :houses, :queenBed, :integer
    add_column :houses, :singleBed, :integer
  end
end
