# == Schema Information
#
# Table name: employees
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type_id    :bigint           not null
#
# Indexes
#
#  index_employees_on_type_id  (type_id)
#
# Foreign Keys
#
#  fk_rails_...  (type_id => empl_types.id)
#
class Employee < ApplicationRecord
  belongs_to :type, class_name: 'EmplType'
  has_many :job_types, through: :type
  has_and_belongs_to_many :houses

  def type_with_name
    "#{type.name} (#{name})"
  end
end
