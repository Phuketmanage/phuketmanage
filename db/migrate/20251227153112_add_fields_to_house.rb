class AddFieldsToHouse < ActiveRecord::Migration[7.0]
  def change
    add_column :houses, :house_no, :string
  end
end
