class AddUserToBookingFiles < ActiveRecord::Migration[6.0]
  def change
    add_reference :booking_files, :user, null: true, foreign_key: true
  end
end
