class AddSyncedToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :synced, :boolean, default: false
    add_index :bookings, :synced
  end
end
