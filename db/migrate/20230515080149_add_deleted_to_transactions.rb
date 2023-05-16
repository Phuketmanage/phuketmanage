class AddDeletedToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :deleted, :boolean, null: false, default: false
  end
end
