class House < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :type, class_name: 'HouseType'
  has_many :bookings, dependent: :destroy
  has_many :prices, dependent: :destroy
  has_many :seasons, dependent: :destroy
  has_many :durations, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :photos, dependent: :destroy, class_name: 'HousePhoto'
  has_many :house_options, dependent: :destroy
  has_many :options, through: :house_options
  has_and_belongs_to_many :employees
  validates :title_ru, :title_ru, :description_en, :description_ru, presence: true

  scope :active, -> { where(unavailable: false) }
  scope :for_rent, -> { where(unavailable: false) }

  def preview
    if image.present?
      url_parts = image.match(/^(.*[\/])(.*)$/)
      image = "#{S3_HOST}#{url_parts[1]}thumb_#{url_parts[2]}"
    else
      image = ""
    end
    return image
  end

  def main_photo
    return image.present? ? "#{S3_HOST}#{image}" : ""
  end


  # Was used after filed number added
  # def add_numbers
  #   houses = House.all
  #   houses.each do |h|
  #     h.update_attributes(number: (('1'..'9').to_a).shuffle[0..rand(1..6)].join)
  #   end
  # end

end
