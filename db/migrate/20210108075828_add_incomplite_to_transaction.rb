class AddIncompliteToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :incomplite, :boolean, null: false, default: false
  end
end
