class AddCashTransferFieldsToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :cash, :boolean, null: false, default: false
    add_column :transactions, :transfer, :boolean, null: false, default: false
  end
end
