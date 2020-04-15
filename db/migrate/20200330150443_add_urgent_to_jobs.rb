class AddUrgentToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :urgent, :boolean, default: false
  end
end
