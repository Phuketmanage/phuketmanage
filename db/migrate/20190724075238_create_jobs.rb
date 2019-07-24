class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.references :job_type, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true
      t.references :house, null: false, foreign_key: true
      t.date :date
      t.string :time
      t.string :comment

      t.timestamps
    end
  end
end
