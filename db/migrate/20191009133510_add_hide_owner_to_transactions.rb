class AddHideOwnerToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :hidden_owner, :boolean, default: false
  end
end
