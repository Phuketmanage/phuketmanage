class House < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :type, class_name: 'HouseType'
  has_many :bookings, dependent: :destroy
  has_many :prices, dependent: :destroy
  has_many :seasons, dependent: :destroy
  has_many :durations, dependent: :destroy
  validates :title_ru, :title_ru, :description_en, :description_ru, presence: true

  scope :active, -> { where(unavailable: false) }

end
