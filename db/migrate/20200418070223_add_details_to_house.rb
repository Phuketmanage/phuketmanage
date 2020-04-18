class AddDetailsToHouse < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :details, :text
  end
end
