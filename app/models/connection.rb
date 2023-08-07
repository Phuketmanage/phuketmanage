# == Schema Information
#
# Table name: connections
#
#  id         :bigint           not null, primary key
#  last_sync  :datetime
#  link       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  house_id   :bigint           not null
#  source_id  :bigint           not null
#
# Indexes
#
#  index_connections_on_house_id   (house_id)
#  index_connections_on_source_id  (source_id)
#
# Foreign Keys
#
#  fk_rails_...  (house_id => houses.id)
#  fk_rails_...  (source_id => sources.id)
#
class Connection < ApplicationRecord
  belongs_to :house
  belongs_to :source
  validates :source_id, :house_id, presence: true
  validates :house_id, uniqueness: { scope: :source_id, message: "Only one link allowed for each source" }
  validates :link, uniqueness: true
end
