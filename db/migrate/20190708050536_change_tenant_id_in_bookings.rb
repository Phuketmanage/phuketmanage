class ChangeTenantIdInBookings < ActiveRecord::Migration[6.0]
  def change
    change_column :bookings, :tenant_id, :bigint, null: true
  end
end
