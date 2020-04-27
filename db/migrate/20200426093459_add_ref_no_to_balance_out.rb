class AddRefNoToBalanceOut < ActiveRecord::Migration[6.0]
  def change
    add_column :balance_outs, :ref_no_iv, :string
    add_column :balance_outs, :ref_no_re, :string
  end
end
