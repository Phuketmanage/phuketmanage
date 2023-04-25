class JobType < ApplicationRecord
  the_schema_is "job_types" do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.string "color"
    t.boolean "for_house_only"
  end

  has_many :jobs, dependent: :destroy
  has_and_belongs_to_many :empl_types
end
