class EmplType < ApplicationRecord
  has_many :employees
  has_and_belongs_to_many :job_type
end
