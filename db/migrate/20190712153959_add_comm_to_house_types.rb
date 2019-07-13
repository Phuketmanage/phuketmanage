class AddCommToHouseTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :house_types, :comm, :integer
  end
end
