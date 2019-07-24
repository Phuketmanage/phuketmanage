class Job < ApplicationRecord
  belongs_to :job_type
  belongs_to :booking, optional: true
  belongs_to :house, optional: true
end
