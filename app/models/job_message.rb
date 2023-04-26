class JobMessage < ApplicationRecord
  the_schema_is "job_messages" do |t|
    t.bigint "job_id", null: false
    t.bigint "sender_id", null: false
    t.text "message"
    t.boolean "is_system"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "file", default: false
  end

  belongs_to :job
  belongs_to :sender, class_name: "User"

  def url
    "#{S3_HOST}#{message}"
  end
end
