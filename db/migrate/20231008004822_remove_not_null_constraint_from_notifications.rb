class RemoveNotNullConstraintFromNotifications < ActiveRecord::Migration[7.0]
  def change
    change_column_null :notifications, :house_id, true
  end
end
