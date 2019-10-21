class DropTableHousePhotos < ActiveRecord::Migration[6.0]
  def change
    drop_table :house_photos
  end
end
