# frozen_string_literal: true

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
  validates :description_en, :description_ru, presence: true
  before_create :generate_number

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
