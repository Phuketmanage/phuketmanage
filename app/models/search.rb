class Search
  include ActiveModel::Model

  attr_accessor :stage, :period, :rs, :rf, :dtnb, :rs_e, :rf_e, :duration

  # validates :period, presence: true
  validate :start_end_correct

  def initialize(attributes = {})
    super
    return if attributes.empty?

    # return if !rs.present? || !rf.present?
    # return if !period.present?
    @period = period
    @rs = rs.present? ? rs.to_date : period.split.first.to_date
    @rf = rf.present? ? rf.to_date : period.split.last.to_date
    @rs_e = rs - dtnb.to_i.days unless rs.nil?
    @rf_e = rf + dtnb.to_i.days unless rf.nil?
    @duration = (rf - rs).to_i if !rs.nil? || !rs.nil?
  end

  def is_house_available?(house_id, booking_id = nil)
    result = {}
    result[:result] = true

    overlapped = if booking_id.nil?
      Booking.where(
        'start <= ? AND finish >= ? AND status != ? AND house_id = ?',
        rf_e, rs_e, Booking.statuses[:canceled], house_id
      ).all
    else
      Booking.where(
        'start <= ? AND finish >= ? AND status != ? AND house_id = ? AND id != ?',
        rf_e, rs_e, Booking.statuses[:canceled], house_id, booking_id
      ).all
    end
    if overlapped.any?
      result[:result] = false
      # result[:overlapped] = overlapped.map(&:number)
      result[:overlapped] = overlapped.map { |b| "#{b.start.strftime('%d.%m.%Y')} - #{b.finish.strftime('%d.%m.%Y')}" }
    end

    if duration_shorter_than_minimal?(house_id)
      result[:result] = false
    end

    result
  end

  def get_prices(houses = [], unavailable_ids = [])
    result = {}
    houses.each do |house|
      total = 0
      durations = house.durations.where(
        'start <= ?  AND finish >= ?', duration, duration
      ).first
      # Management can check price out of min and max house period
      # if durations.nil? && house.durations.any? && management
      #   min = house.durations.minimum(:finish)
      #   max = house.durations.maximum(:finish)
      #   d = house.durations.order(:start)
      #   durations = d.first if duration < min
      #   durations = d.last if duration > max
      # end
      next if durations.nil?

      seasons = get_seasons house.seasons
      seasons.each do |s|
        amount = house.prices.where(duration_id: durations.id,
                                    season_id: s[:id]).first.amount
        price = amount * s[:days]
        total += price
      end
      result[house.id] = { total: total,
                           per_day: total / duration.to_f.round,
                           unavailable: unavailable_ids.include?(house.id) }
    end
    result
  end

  def get_seasons(seasons)
    overlapping_seasons = []
    overlapped_info = {}
    days_left = duration
    year_modifier = 0
    year = rs.year
    until days_left == 0
      seasons.each_with_index do |s, index|
        trans_season_modifier = 0
        trans_season_modifier = -1 if s.ssm > s.sfm
        ss = Time.parse("#{s.ssd}.#{s.ssm}.#{year + trans_season_modifier}").to_date
        sf = Time.parse("#{s.sfd}.#{s.sfm}.#{year}").to_date
        year += 1 if index == seasons.size - 1
        next unless overlapping? ss, sf, rs, rf

        overlapping_seasons << get_overlapped_info(s.id, ss, sf, rs, rf)
        days_left -= overlapping_seasons.last[:days]
        break if days_left == 0
      end
      break if year_modifier > 1
    end
    overlapping_seasons
  end

  def get_overlapped_info(sid, ss, sf, rs, rf)
    s = [rs, ss].max
    f = [rf, sf].min
    days = (f.to_date - s.to_date).to_i
    hash = { id: sid, days: days, ss: ss, sf: sf }
  end

  def overlapping?(ss, sf, rs, rf)
    if rs < sf && rf > ss
      true
    else
      false
    end
  end

  def get_available_houses(management = false)
    overlapped_bookings = Booking.where(
      'start <= ? AND finish >= ? AND status != ?', rf_e, rs_e,
      Booking.statuses[:canceled]
    ).all.map do |b|
                            { house_id: b.house_id, start: b.start, finish: b.finish } end
    booked_house_ids = overlapped_bookings.map { |b| b[:house_id] }
    available_houses = if booked_house_ids.any? && !management
      { available: House.for_rent.where.not(id: booked_house_ids).order("RANDOM()"),
        unavailable_ids: [] }
    else
      { available: House.for_rent.all.order("RANDOM()"),
        unavailable_ids: booked_house_ids }
    end
  end

  def duration_shorter_than_minimal?(house_id)
    !check_house_min_booking_period(house_id)
  end

  def check_house_min_booking_period(house_id)
    min_house_period = Duration.where(house_id:).minimum(:start)
    if min_house_period.nil?
      errors.add(:base, I18n.t('search.unavailable'))
      false
    else
      if @duration >= min_house_period
        return true
      else
        errors.add(:base, I18n.t('search.duration_shorter_than_minimal', min_house_period:))
        false
      end
    end
  end

  private

  def start_end_correct
    return if rs.nil? || rf.nil?

    errors.add(:base, I18n.t('search.rf_less_rs')) if rf < rs
    if rs < Time.now.in_time_zone('Bangkok').to_date || rf < Time.now.in_time_zone('Bangkok').to_date
      errors.add(:base, I18n.t('search.in_the_past'))
    end
    errors.add(:base, I18n.t('search.too_soon')) if (rs - Time.now.in_time_zone('Bangkok').to_date).to_i < 2
    errors.add(:base, I18n.t('search.too_short')) if duration < 5
  end
end
