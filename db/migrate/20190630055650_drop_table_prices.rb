class DropTablePrices < ActiveRecord::Migration[6.0]
  def change
    drop_table :prices
  end
end
