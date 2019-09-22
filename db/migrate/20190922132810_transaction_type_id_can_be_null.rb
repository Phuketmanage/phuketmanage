class TransactionTypeIdCanBeNull < ActiveRecord::Migration[6.0]
  def change
    change_column :transactions, :type_id, :bigint, null: :true
  end
end
