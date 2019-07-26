class AddCreatorToJobs < ActiveRecord::Migration[6.0]
  def change
    add_reference :jobs, :creator, null: false, foreign_key: {to_table: :users}
  end
end
