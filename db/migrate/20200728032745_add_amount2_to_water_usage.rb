class AddAmount2ToWaterUsage < ActiveRecord::Migration[6.0]
  def change
    add_column :water_usages, :amount_2, :integer
  end
end
