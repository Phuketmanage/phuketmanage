class Connection < ApplicationRecord
  belongs_to :house
  belongs_to :source
  validates :source_id, presence: true
end
