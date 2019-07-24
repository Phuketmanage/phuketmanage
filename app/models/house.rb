class House < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :type, class_name: 'HouseType'
  has_many :bookings, dependent: :destroy
  has_many :prices, dependent: :destroy
  has_many :seasons, dependent: :destroy
  has_many :durations, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_many :jobs, dependent: :destroy
  validates :title_ru, :title_ru, :description_en, :description_ru, presence: true

  scope :active, -> { where(unavailable: false) }
  scope :for_rent, -> { where(unavailable: false) }

  # Was used after filed number added
  # def add_numbers
  #   houses = House.all
  #   houses.each do |h|
  #     h.update_attributes(number: (('1'..'9').to_a).shuffle[0..rand(1..6)].join)
  #   end
  # end

end
