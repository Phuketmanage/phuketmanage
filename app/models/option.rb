class Option < ApplicationRecord
  the_schema_is "options" do |t|
    t.string "title_en"
    t.string "title_ru"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "zindex"
  end

  has_many :house_options, dependent: :destroy
  has_many :houses, through: :house_options
end
