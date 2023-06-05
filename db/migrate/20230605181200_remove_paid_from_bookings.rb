class RemovePaidFromBookings < ActiveRecord::Migration[6.1]
  def change
    remove_column :bookings, :paid, :boolean
  end
end
