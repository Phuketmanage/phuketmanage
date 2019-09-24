class AddReferenceToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :booking, null: true, foreign_key: true
  end
end
