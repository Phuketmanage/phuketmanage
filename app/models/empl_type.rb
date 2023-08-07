# == Schema Information
#
# Table name: empl_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class EmplType < ApplicationRecord
  has_many :employees, dependent: :destroy, foreign_key: 'type_id'
  has_and_belongs_to_many :job_type
end
