class Job < ApplicationRecord
  the_schema_is "jobs" do |t|
    t.bigint "job_type_id", null: false
    t.bigint "booking_id"
    t.bigint "house_id"
    t.string "time"
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.date "plan"
    t.date "closed"
    t.text "job"
    t.bigint "creator_id", null: false
    t.bigint "employee_id"
    t.date "collected"
    t.date "sent"
    t.integer "rooms"
    t.integer "price"
    t.string "before"
    t.integer "status", default: 0
    t.boolean "urgent", default: false
    t.boolean "paid_by_tenant", default: false, null: false
  end

  enum status: {  inbox: 0, in_progress: 1, done: 2, paused: 3,
                  cancelled: 4, archived: 5 }

  belongs_to :job_type
  belongs_to :user, optional: true
  belongs_to :creator, class_name: 'User'
  belongs_to :booking, optional: true
  belongs_to :house, optional: true
  belongs_to :employee, optional: true
  has_many :job_messages, dependent: :destroy
  has_many :job_tracks, dependent: :destroy
  # validates :plan, presence: true
end
