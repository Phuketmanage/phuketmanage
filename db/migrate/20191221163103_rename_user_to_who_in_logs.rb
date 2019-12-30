class RenameUserToWhoInLogs < ActiveRecord::Migration[6.0]
  def change
    rename_column :logs, :user, :who
  end
end
