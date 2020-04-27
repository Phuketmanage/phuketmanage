class CreateHouseGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :house_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
