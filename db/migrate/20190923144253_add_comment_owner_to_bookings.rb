class AddCommentOwnerToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :comment_owner, :string
  end
end
