class HouseType < ApplicationRecord
  the_schema_is "house_types" do |t|
    t.string "name_en"
    t.string "name_ru"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "comm"
  end

  has_many :houses, dependent: :nullify, foreign_key: 'type_id'
end
