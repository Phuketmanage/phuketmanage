class AddFieldsToJobTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :job_types, :code, :string
    add_column :job_types, :color, :string
  end
end
