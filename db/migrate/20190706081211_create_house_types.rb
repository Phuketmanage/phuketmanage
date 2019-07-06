class CreateHouseTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :house_types do |t|
      t.string :name_en
      t.string :name_ru

      t.timestamps
    end
  end
end
