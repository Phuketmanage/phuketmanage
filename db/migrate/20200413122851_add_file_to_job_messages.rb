class AddFileToJobMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :job_messages, :file, :boolean, default: false
  end
end
