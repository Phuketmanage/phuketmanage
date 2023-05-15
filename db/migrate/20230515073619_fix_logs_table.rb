class FixLogsTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :logs, :when
    rename_column :logs, :action, :what
    add_column :logs, :with, :string, default: nil
  end
end
