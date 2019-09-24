class AddPaidToBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :paid, :boolean, default: false
  end
end
