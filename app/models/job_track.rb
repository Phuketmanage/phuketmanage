class JobTrack < ApplicationRecord
  the_schema_is "job_tracks" do |t|
    t.bigint "job_id", null: false
    t.bigint "user_id", null: false
    t.datetime "visit_time", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  belongs_to :job
  belongs_to :user
end
