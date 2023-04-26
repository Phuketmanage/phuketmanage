class Setting < ApplicationRecord
  the_schema_is "settings" do |t|
    t.string "var"
    t.string "value"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
end
