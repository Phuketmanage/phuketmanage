class CreateHouses < ActiveRecord::Migration[6.0]
  def change
    create_table :houses do |t|
      t.string :title_en
      t.string :title_ru
      t.text :description_en
      t.text :description_ru
      t.references :owner, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
