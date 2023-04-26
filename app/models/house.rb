class House < ApplicationRecord
  the_schema_is "houses" do |t|
    t.string "title_en"
    t.string "title_ru"
    t.text "description_en"
    t.text "description_ru"
    t.bigint "owner_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "type_id", null: false
    t.string "code"
    t.integer "size"
    t.integer "plot_size"
    t.integer "rooms"
    t.integer "bathrooms"
    t.boolean "pool"
    t.string "pool_size"
    t.boolean "communal_pool"
    t.boolean "parking"
    t.integer "parking_size"
    t.boolean "unavailable", default: false
    t.string "number", limit: 10
    t.string "secret"
    t.boolean "rental", default: false
    t.boolean "maintenance", default: false
    t.boolean "outsource_cleaning", default: false
    t.boolean "outsource_linen", default: false
    t.string "address"
    t.string "google_map"
    t.string "image"
    t.integer "capacity"
    t.boolean "seaview", default: false
    t.integer "kingBed"
    t.integer "queenBed"
    t.integer "singleBed"
    t.text "priceInclude_en"
    t.text "priceInclude_ru"
    t.text "cancellationPolicy_en"
    t.text "cancellationPolicy_ru"
    t.text "rules_en"
    t.text "rules_ru"
    t.text "other_ru"
    t.text "other_en"
    t.text "details"
    t.bigint "house_group_id"
    t.integer "water_meters", default: 1
    t.boolean "water_reading", default: false
    t.boolean "balance_closed", default: false, null: false
    t.boolean "hide_in_timeline", default: false, null: false
  end

  belongs_to :owner, class_name: "User"
  belongs_to :type, class_name: 'HouseType'
  belongs_to :house_group, optional: true
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
  has_many :water_usages, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_and_belongs_to_many :employees
  has_and_belongs_to_many :locations
  validates :description_en, :description_ru, presence: true
  before_save :generate_title

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

  def option(title_en)
    option = Option.find_by(title_en: title_en)
    return false if !option
    options.where(id: option.id).any? ? true : false
  end

  private
  
  def generate_title()
    locations_en = self.locations.map{|x| x.name_en}.join(" ")
    locations_ru = self.locations.map{|x| x.name_ru}.join(" ")
    self.title_en = [self.code, self.type.name_en, self.rooms, "BDR", self.bathrooms, "BTH", locations_en].join(' ')
    self.title_ru = [self.code, self.type.name_ru, self.rooms, "СП", self.bathrooms, "ВН", locations_ru].join(' ')
  end
  # Was used after filed number added
  # def add_numbers
  #   houses = House.all
  #   houses.each do |h|
  #     h.update_attributes(number: (('1'..'9').to_a).shuffle[0..rand(1..6)].join)
  #   end
  # end

end
