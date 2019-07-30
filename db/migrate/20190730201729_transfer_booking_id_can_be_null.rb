class TransferBookingIdCanBeNull < ActiveRecord::Migration[6.0]
  def change
    change_column :transfers, :booking_id, :bigint, null: :true
  end
end
