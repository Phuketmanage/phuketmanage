class RemoveActinoFromLogs < ActiveRecord::Migration[6.0]
  def change
    remove_column :logs, :actino
  end
end
