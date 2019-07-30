class AddArrDepClientDetailsToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :in_details, :string
    add_column :bookings, :out_details, :string
    add_column :bookings, :transfer_in, :boolean, default: false
    add_column :bookings, :transfer_out, :boolean, default: false
    add_column :bookings, :client_details, :string
  end
end
