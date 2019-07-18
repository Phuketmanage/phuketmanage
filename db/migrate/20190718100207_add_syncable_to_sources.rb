class AddSyncableToSources < ActiveRecord::Migration[6.0]
  def change
    add_column :sources, :syncable, :boolean, default: false
    add_index :sources, :syncable
  end
end
