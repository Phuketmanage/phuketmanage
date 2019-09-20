class TransactionUserIdCanBeNull < ActiveRecord::Migration[6.0]
  def change
    change_column :transactions, :user_id, :bigint, null: :true
  end
end
