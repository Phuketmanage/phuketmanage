class TransactionHouseIdCanBeNull < ActiveRecord::Migration[6.0]
  def change
    change_column :transactions, :house_id, :bigint, null: :true
  end
end
