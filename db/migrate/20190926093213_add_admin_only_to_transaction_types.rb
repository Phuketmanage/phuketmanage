class AddAdminOnlyToTransactionTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :transaction_types, :admin_only, :boolean, default: false
  end
end
