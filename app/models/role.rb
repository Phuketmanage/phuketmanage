class Role < ApplicationRecord
  the_schema_is "roles" do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  has_and_belongs_to_many :users

end
