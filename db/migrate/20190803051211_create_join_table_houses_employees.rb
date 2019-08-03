class CreateJoinTableHousesEmployees < ActiveRecord::Migration[6.0]
  def change
    create_join_table :houses, :employees do |t|
      t.index [:house_id, :employee_id], unique: true
      # t.index [:employee_id, :house_id]
    end
  end
end
