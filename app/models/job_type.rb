class JobType < ApplicationRecord
  has_many :jobs, dependent: :destroy
end
