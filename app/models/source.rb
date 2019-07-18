class Source < ApplicationRecord
  has_many :connections, dependent: :destroy
  validates :name, presence: true
  scope :syncable, -> { where(syncable: true) }

end
