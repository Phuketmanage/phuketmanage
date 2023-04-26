class Transfer < ApplicationRecord
  the_schema_is "transfers" do |t|
    t.bigint "booking_id"
    t.date "date"
    t.integer "trsf_type"
    t.string "from"
    t.string "time"
    t.string "client"
    t.string "pax"
    t.string "to"
    t.string "remarks"
    t.string "booked_by"
    t.string "number"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  enum trsf_type: { IN: 0, OUT: 1 }
  enum status: { sent: 0, confirmed: 1, amended: 2, canceling: 3, canceled: 4 }

  belongs_to :booking, optional: :true
end
