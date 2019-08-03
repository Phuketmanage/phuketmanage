class AddEmployeeToJobs < ActiveRecord::Migration[6.0]
  def change
    add_reference :jobs, :employee, null: true, foreign_key: true
  end
end
