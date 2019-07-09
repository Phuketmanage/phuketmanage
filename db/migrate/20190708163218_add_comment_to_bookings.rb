class AddCommentToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :comment, :text
  end
end
