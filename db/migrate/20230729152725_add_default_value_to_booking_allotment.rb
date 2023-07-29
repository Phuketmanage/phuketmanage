class AddDefaultValueToBookingAllotment < ActiveRecord::Migration[7.0]
  def up
    change_column :bookings, :allotment, :boolean, default: false
  end

  def down
    change_column :bookings, :allotment, :boolean, default: nil
  end
end
