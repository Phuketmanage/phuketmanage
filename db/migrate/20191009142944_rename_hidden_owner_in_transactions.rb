class RenameHiddenOwnerInTransactions < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :hidden_owner, :for_acc
  end
end
