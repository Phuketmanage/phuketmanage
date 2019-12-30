class RemoveUserFromLogs < ActiveRecord::Migration[6.0]
  def change
    remove_column :logs, :user_id
  end
end
