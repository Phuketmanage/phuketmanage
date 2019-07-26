class AddFieldsToJobs < ActiveRecord::Migration[6.0]
  def change
    add_reference :jobs, :user, null: true, foreign_key: true
    add_column :jobs, :plan, :date
    add_column :jobs, :closed, :date
    add_column :jobs, :job, :text
    change_column :jobs, :comment, :text
  end
end
