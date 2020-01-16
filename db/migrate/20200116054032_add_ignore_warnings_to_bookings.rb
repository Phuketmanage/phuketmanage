class AddIgnoreWarningsToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :ignore_warnings, :boolean, default: false
  end
end
