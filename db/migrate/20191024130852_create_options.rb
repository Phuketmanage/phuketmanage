class CreateOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.string :title_en
      t.string :title_ru

      t.timestamps
    end
  end
end
