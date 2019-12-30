class AddAcdtionToLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :logs, :actino, :string
  end
end
