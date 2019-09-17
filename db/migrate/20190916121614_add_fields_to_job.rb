class AddFieldsToJob < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :collected, :date
    add_column :jobs, :sent, :date
    add_column :jobs, :rooms, :integer
    add_column :jobs, :price, :integer
  end
end
