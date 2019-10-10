class AddRefnoToBalances < ActiveRecord::Migration[6.0]
  def change
    add_column :balances, :ref_no, :string
  end
end
