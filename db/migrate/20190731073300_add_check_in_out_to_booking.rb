class AddCheckInOutToBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :no_check_in, :boolean, default: false
    add_column :bookings, :no_check_out, :boolean, default: false
  end
end
