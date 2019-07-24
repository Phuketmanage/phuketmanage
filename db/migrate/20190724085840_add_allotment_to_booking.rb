class AddAllotmentToBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :allotment, :boolean
  end
end
