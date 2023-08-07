class Employee < ApplicationRecord
  belongs_to :type, class_name: 'EmplType'
  has_many :job_types, through: :type
  has_and_belongs_to_many :houses

  def type_with_name
    "#{type.name} (#{name})"
  end
end
