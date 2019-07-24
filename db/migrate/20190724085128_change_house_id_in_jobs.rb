class ChangeHouseIdInJobs < ActiveRecord::Migration[6.0]
  def change
    change_column :jobs, :house_id, :bigint, null: true
  end
end
