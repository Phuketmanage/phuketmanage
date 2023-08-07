class Source < ApplicationRecord
  has_many :connections, dependent: :destroy
  has_many :bookings, dependent: :nullify
  validates :name, presence: true
  scope :syncable, -> { where(syncable: true) }
end
