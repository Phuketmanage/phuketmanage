class AddDateToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :date, :date
  end
end
