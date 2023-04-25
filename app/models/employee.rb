class Employee < ApplicationRecord
  the_schema_is "employees" do |t|
    t.bigint "type_id", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  belongs_to :type, class_name: 'EmplType'
  has_many :job_types, through: :type
  has_and_belongs_to_many :houses


  def type_with_name
    "#{type.name} (#{name})"
  end
end
