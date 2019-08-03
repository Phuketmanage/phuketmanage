class CreateJoinTableHousesEmplTypes < ActiveRecord::Migration[6.0]
  def change
    create_join_table :job_types, :empl_types do |t|
      t.index [:job_type_id, :empl_type_id], unique: true
      # t.index [:empl_type_id, :job_type_id]
    end
  end
end
