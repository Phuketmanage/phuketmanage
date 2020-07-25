class AddShowCommToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :show_comm, :boolean, default: false
  end
end
