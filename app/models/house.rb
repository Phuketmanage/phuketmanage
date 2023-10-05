# frozen_string_literal: true

# == Schema Information
#
# Table name: houses
#
#  id                    :bigint           not null, primary key
#  address               :string
#  balance_closed        :boolean          default(FALSE), not null
#  bathrooms             :integer
#  cancellationPolicy_en :text
#  cancellationPolicy_ru :text
#  capacity              :integer
#  code                  :string
#  communal_pool         :boolean
#  description_en        :text
#  description_ru        :text
#  details               :text
#  google_map            :string
#  hide_in_timeline      :boolean          default(FALSE), not null
#  image                 :string
#  kingBed               :integer
#  maintenance           :boolean          default(FALSE)
#  number                :string(10)
#  other_en              :text
#  other_ru              :text
#  outsource_cleaning    :boolean          default(FALSE)
#  outsource_linen       :boolean          default(FALSE)
#  parking               :boolean
#  parking_size          :integer
#  photo_link            :string
#  plot_size             :integer
#  pool                  :boolean
#  pool_size             :string
#  priceInclude_en       :text
#  priceInclude_ru       :text
#  project               :string
#  queenBed              :integer
#  rental                :boolean          default(FALSE)
#  rooms                 :integer
#  rules_en              :text
#  rules_ru              :text
#  seaview               :boolean          default(FALSE)
#  secret                :string
#  singleBed             :integer
#  size                  :integer
#  title_en              :string
#  title_ru              :string
#  unavailable           :boolean          default(FALSE)
#  water_meters          :integer          default(1)
#  water_reading         :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  house_group_id        :bigint
#  owner_id              :bigint           not null
#  type_id               :bigint           not null
#
# Indexes
#
#  index_houses_on_bathrooms       (bathrooms)
#  index_houses_on_code            (code)
#  index_houses_on_communal_pool   (communal_pool)
#  index_houses_on_house_group_id  (house_group_id)
#  index_houses_on_number          (number) UNIQUE
#  index_houses_on_owner_id        (owner_id)
#  index_houses_on_parking         (parking)
#  index_houses_on_rooms           (rooms)
#  index_houses_on_type_id         (type_id)
#  index_houses_on_unavailable     (unavailable)
#
# Foreign Keys
#
#  fk_rails_...  (house_group_id => house_groups.id)
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (type_id => house_types.id)
#
class House < ApplicationRecord
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
  before_create :generate_number

  validates :description_en, :description_ru, presence: true
  validates :rooms, presence: true, numericality: { greater_than: 0 }, on: :for_rent

  scope :active, -> { joins(:owner).where('users.balance_closed': false).where(balance_closed: false) }
  scope :inactive, -> { joins(:owner).where('users.balance_closed': true).or(where(balance_closed: true)) }
  scope :for_rent, -> { active.where(unavailable: false).order(:code) }
  scope :not_for_rent, -> { active.where(unavailable: true).order(:code) }
  scope :for_timeline, -> { active.where(hide_in_timeline: false).order(:unavailable, :house_group_id, :code) }

  def occupied_days(dtnb = 0)
    starting_date = Date.current
    bookings = self.bookings.active.where(finish: starting_date..).pluck(:start, :finish)

    return [] if bookings.blank?

    bookings.map do |range|
      # Wrap dates with days to next booking
      from = range.first.advance(days: -dtnb.to_i).iso8601
      to = range.last.advance(days: dtnb.to_i).iso8601

      # Create Flatpickr acceptable format
      {
        from:,
        to:
      }
    end
  end

  def preview
    if image.present?
      url_parts = image.match(%r{^(.*/)(.*)$})
      image = "#{S3_HOST}#{url_parts[1]}thumb_#{url_parts[2]}"
    else
      image = ""
    end
    image
  end

  def main_photo
    image.present? ? "#{S3_HOST}#{image}" : ""
  end

  def option(title_en)
    option = Option.find_by(title_en:)
    return false unless option

    options.where(id: option.id).any?
  end

  def generated_title(locale)
    if locale == :ru
      [type.name_ru, rooms, "СП", *locations.pluck(:name_ru)].join(' ')
    else
      [type.name_en, rooms, "BDR", *locations.pluck(:name_en)].join(' ')
    end
  end

  private

  def generate_number
    number_unique = false
    until number_unique
      number = ('1'..'9').to_a.shuffle[0..rand(1..6)].join
      house = House.find_by(number:)
      number_unique = true if house.nil?
    end
    self.number = number
  end
  # Was used after filed number added
  # def add_numbers
  #   houses = House.all
  #   houses.each do |h|
  #     h.update_attributes(number: (('1'..'9').to_a).shuffle[0..rand(1..6)].join)
  #   end
  # end
end
