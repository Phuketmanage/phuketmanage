class Connection < ApplicationRecord
  belongs_to :house
  belongs_to :source
  validates :source_id, :house_id, presence: true
  validates_uniqueness_of :house_id, scope: :source_id, message: "Only one link allowed for each source"
  validates :link, uniqueness: true
end
