class Search
  include ActiveModel::Model

  attr_accessor :stage, :rs, :rf, :dtnb, :rs_e, :rf_e, :duration

  validates :rs, :rf, presence: true
  validate :start_end_correct

  def initialize(attributes = {})
    super
    return if attributes.empty?
    @rs = rs.to_date
    @rf = rf.to_date
    @rs_e = rs - dtnb.to_i.days
    @rf_e = rf + dtnb.to_i.days
    @duration = (rf-rs).to_i
  end

  def is_house_available? house_id, booking_id = nil
    result = {}
    result[:result] = true

    if booking_id.nil?
      overlapped = Booking.where(
        'start < ? AND finish > ? AND status != ? AND house_id = ?',
        rf_e, rs_e, Booking.statuses[:canceled], house_id).all
    else
      overlapped = Booking.where(
        'start < ? AND finish > ? AND status != ? AND house_id = ? AND id != ?',
        rf_e, rs_e, Booking.statuses[:canceled], house_id, booking_id).all
    end
    if overlapped.any?
      result[:result] = false
      result[:overlapped] = overlapped.map(&:number)
    end
    return result
  end

  def get_prices houses = []
    # t1 = Time.now
    result = {}

    houses.each do |house|
      total = 0

      durations = house.durations.where(
        'start <= ?  AND finish >= ?', duration, duration).first
      next if durations.nil?
      seasons = get_seasons house.seasons
      seasons.each do |s|
        amount = house.prices.where(duration_id: durations.id,
                                    season_id: s[:id]).first.amount
        price = amount*s[:days]
        # puts "#{s[:ss].strftime('%d.%m.%Y')}-#{s[:sf].strftime('%d.%m.%Y')} / #{s[:days]} = #{price}"
        total += price
      end
      result[house.id] = {total: total, per_day: total/duration.to_f.round()}
    end
    # puts "#{(Time.now-t1)}ms"
    return result
  end

  def get_seasons seasons
    overlapping_seasons = []
    overlapped_info = {}
    days_left = duration
    year_modifier = 0
    until days_left == 0 do
      year = rs.year+year_modifier
      seasons.each_with_index do |s, index|
        season_of_next_year = 0
        season_of_next_year = 1 if s.ssm > s.sfm
        ss = Time.parse("#{s.ssd}.#{s.ssm}.#{year}").to_date
        sf = Time.parse("#{s.sfd}.#{s.sfm}.#{year+season_of_next_year}").to_date
        year_modifier +=1 if index == seasons.size-1
        next if !overlapping? ss, sf, rs, rf
        overlapping_seasons << get_overlapped_info(s.id, ss, sf, rs, rf)
        days_left -= overlapping_seasons.last[:days]
        break if days_left == 0
      end
      break if year_modifier > 1
    end
    return overlapping_seasons
  end

  def get_overlapped_info sid, ss, sf, rs, rf
    s = [rs,ss].max
    f = [rf,sf].min
    days = (f.to_date - s.to_date).to_i
    hash = { id: sid, days: days , ss: ss, sf: sf }
  end

  def overlapping? (ss, sf, rs, rf)
    if rs < sf && rf > ss
      return true
    else
      return false
    end
  end

  def get_available_houses
    overlapped_bookings = Booking.where(
      'start < ? AND finish > ? AND status != ?', rf_e, rs_e,
      Booking.statuses[:canceled]).all.map{
      |b| {house_id: b.house_id, start: b.start, finish: b.finish}}
    booked_house_ids = overlapped_bookings.map{|b| b[:house_id]}
    if booked_house_ids.any?
      available_houses = House.for_rent.where.not(id: booked_house_ids)
    else
      available_houses = House.for_rent.all
    end

  end

  private

    def start_end_correct
      return if rs.nil? || rf.nil?
      if rf < rs
        errors.add(:rf, I18n.t('search.rf_less_rs'))
      end
      if rs < Time.now.in_time_zone('Bangkok').to_date || rf < Time.now.in_time_zone('Bangkok').to_date
        errors.add(:duration, I18n.t('search.in_the_past'))
      end
      if (rs - Time.now.in_time_zone('Bangkok').to_date).to_i < 2
        errors.add(:rs, I18n.t('search.too_soon'))
      end
      if duration < 5
        errors.add(:duration, I18n.t('search.too_short'))
      end
    end


end
