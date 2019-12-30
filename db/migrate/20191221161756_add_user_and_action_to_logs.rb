class AddUserAndActionToLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :logs, :user, :string
    add_column :logs, :action, :string
  end
end
