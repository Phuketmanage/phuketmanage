class AddPriceIncludeFireldToHouse < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :priceInclude_en, :text
    add_column :houses, :priceInclude_ru, :text
    add_column :houses, :cancellationPolicy_en, :text
    add_column :houses, :cancellationPolicy_ru, :text
  end
end
