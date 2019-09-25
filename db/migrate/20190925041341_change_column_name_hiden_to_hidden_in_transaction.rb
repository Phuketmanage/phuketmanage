class ChangeColumnNameHidenToHiddenInTransaction < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :hiden, :hidden
  end
end
