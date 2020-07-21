class AddShowToTransactionFiles < ActiveRecord::Migration[6.0]
  def change
    add_column :transaction_files, :show, :boolean, default: false
  end
end
