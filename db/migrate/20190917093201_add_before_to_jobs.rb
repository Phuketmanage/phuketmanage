class AddBeforeToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :before, :string
  end
end
