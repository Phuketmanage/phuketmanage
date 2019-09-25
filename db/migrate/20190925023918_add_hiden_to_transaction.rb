class AddHidenToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :hiden, :boolean, default: false
  end
end
