class AddRefNoToBalanceOuts < ActiveRecord::Migration[6.0]
  def change
    add_column :balance_outs, :ref_no, :string
  end
end
