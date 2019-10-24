class CreateHouseOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :house_options do |t|
      t.references :house, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.string :comment_en
      t.string :comment_ru

      t.timestamps
    end
  end
end
