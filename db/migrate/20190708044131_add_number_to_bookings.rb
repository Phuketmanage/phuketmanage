class AddNumberToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :number, :string
    add_index :bookings, :number, unique: true
  end
end
