class AddImageFieldToHouse < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :image, :string
  end
end
