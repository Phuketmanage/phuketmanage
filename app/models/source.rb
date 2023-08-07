# == Schema Information
#
# Table name: sources
#
#  id         :bigint           not null, primary key
#  name       :string
#  syncable   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sources_on_syncable  (syncable)
#
class Source < ApplicationRecord
  has_many :connections, dependent: :destroy
  has_many :bookings, dependent: :nullify
  validates :name, presence: true
  scope :syncable, -> { where(syncable: true) }
end
