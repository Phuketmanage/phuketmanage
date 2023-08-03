class AddPositionToHousePhotos < ActiveRecord::Migration[7.0]
  def change
    add_column :house_photos, :position, :integer
  end
end
