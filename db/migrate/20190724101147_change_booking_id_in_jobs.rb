class ChangeBookingIdInJobs < ActiveRecord::Migration[6.0]
  def change
    change_column :jobs, :booking_id, :bigint, null: true
  end
end
