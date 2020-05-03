class AddTaxIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tax_no, :string
  end
end
