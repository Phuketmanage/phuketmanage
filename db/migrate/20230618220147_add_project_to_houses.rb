class AddProjectToHouses < ActiveRecord::Migration[6.1]
  def change
    add_column :houses, :project, :string
  end
end
