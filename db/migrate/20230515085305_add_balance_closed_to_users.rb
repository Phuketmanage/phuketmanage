class AddBalanceClosedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :balance_closed, :boolean, default: false, null: false
  end
end
