class DropTableHousePhotos < ActiveRecord::Migration[6.0]
  def change
    drop_table :house_photos, if_exists: true
  end
end
