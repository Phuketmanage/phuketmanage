class AddPriceFieldsToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :sale, :integer
    add_column :bookings, :agent, :integer
    add_column :bookings, :comm, :integer
    add_column :bookings, :nett, :integer
  end
end
