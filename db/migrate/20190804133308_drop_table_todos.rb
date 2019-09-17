class DropTableTodos < ActiveRecord::Migration[6.0]
  def change
    drop_table :todos, if_exists: true
  end
end
