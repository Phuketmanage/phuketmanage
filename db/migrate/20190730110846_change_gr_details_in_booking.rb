class ChangeGrDetailsInBooking < ActiveRecord::Migration[6.0]
  def change
    remove_column :bookings, :in_details
    remove_column :bookings, :out_details
    add_column :bookings, :comment_gr, :text
  end
end
