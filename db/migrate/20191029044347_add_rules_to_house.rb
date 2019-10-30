class AddRulesToHouse < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :rules_en, :text
    add_column :houses, :rules_ru, :text
  end
end
