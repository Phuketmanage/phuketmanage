class Notification < ApplicationRecord
  the_schema_is "notifications" do |t|
    t.string "level"
    t.string "text"
    t.bigint "house_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  belongs_to :house, optional: true
end
