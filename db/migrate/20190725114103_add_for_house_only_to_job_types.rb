class AddForHouseOnlyToJobTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :job_types, :for_house_only, :boolean
  end
end
