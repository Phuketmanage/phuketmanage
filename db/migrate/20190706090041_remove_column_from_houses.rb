class RemoveColumnFromHouses < ActiveRecord::Migration[6.0]
  def change

    remove_column :houses, :house_types_id, :bigint
  end
end
