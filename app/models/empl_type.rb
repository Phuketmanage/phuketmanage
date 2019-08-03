class EmplType < ApplicationRecord
  has_many :employees, dependent: :destroy, foreign_key: 'type_id'
  has_and_belongs_to_many :job_type
end
