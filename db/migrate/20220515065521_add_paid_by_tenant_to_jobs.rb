class AddPaidByTenantToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :paid_by_tenant, :boolean, null: false, default: false
  end
end
