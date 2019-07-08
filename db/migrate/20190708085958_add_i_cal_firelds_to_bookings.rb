class AddICalFireldsToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :ical_UID, :string
    add_column :bookings, :source_id, :integer
    add_index :bookings, :source_id
  end
end
