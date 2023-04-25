class EmplType < ApplicationRecord
  the_schema_is "empl_types" do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  has_many :employees, dependent: :destroy, foreign_key: 'type_id'
  has_and_belongs_to_many :job_type
end
