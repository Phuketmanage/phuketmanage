class AddRefNoToBalance < ActiveRecord::Migration[6.0]
  def change
    add_column :balances, :ref_no_iv, :string
    add_column :balances, :ref_no_re, :string
  end
end
