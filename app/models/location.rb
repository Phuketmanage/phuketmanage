class Location < ApplicationRecord
  the_schema_is "locations" do |t|
    t.string "name_en"
    t.string "name_ru"
    t.text "descr_en"
    t.text "descr_ru"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  has_and_belongs_to_many :houses
end
