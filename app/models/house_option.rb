class HouseOption < ApplicationRecord
  the_schema_is "house_options" do |t|
    t.bigint "house_id", null: false
    t.bigint "option_id", null: false
    t.string "comment_en"
    t.string "comment_ru"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  belongs_to :house
  belongs_to :option
end
