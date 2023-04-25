class HouseGroup < ApplicationRecord
  the_schema_is "house_groups" do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  has_many :houses, dependent: :nullify
end
