class CreateHousePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :house_photos do |t|
      t.references :house, null: false, foreign_key: true
      t.string :url
      t.string :title_en
      t.string :title_ru

      t.timestamps
    end
  end
end
