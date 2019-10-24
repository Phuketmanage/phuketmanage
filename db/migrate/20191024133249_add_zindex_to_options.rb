class AddZindexToOptions < ActiveRecord::Migration[6.0]
  def change
    add_column :options, :zindex, :integer
  end
end
