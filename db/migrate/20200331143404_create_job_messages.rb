class CreateJobMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :job_messages do |t|
      t.references :job, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users}
      t.text :message
      t.boolean :is_system

      t.timestamps
    end
  end
end
