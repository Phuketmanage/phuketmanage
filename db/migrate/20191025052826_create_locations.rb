class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :name_en
      t.string :name_ru
      t.text :descr_en
      t.text :descr_ru

      t.timestamps
    end
  end
end
