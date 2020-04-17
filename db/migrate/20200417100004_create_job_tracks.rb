class CreateJobTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :job_tracks do |t|
      t.references :job, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :visit_time, null: false

      t.timestamps
    end
  end
end
