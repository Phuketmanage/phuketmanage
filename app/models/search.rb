class Search
  include ActiveModel::Model

  attr_accessor :stage, :rs, :rf, :duration

  validates :rs, :rf, presence: true
  validate :start_end_correct


  def initialize(attributes = {})
    @rs = attributes[:rs].to_date if !attributes[:rs].nil?
    @rf = attributes[:rf].to_date if !attributes[:rs].nil?
    @duration = (rf-rs).to_i if !rf.nil? && !rs.nil?
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

def get_prices_old houses = []
    t1 = Time.now
    result = {}
    houses.each do |house|
      total = 0
      durations = house.durations.where(
        'start <= ?  AND finish >= ?', duration, duration).first
    # byebug
      next if durations.nil?
      seasons = get_seasons_old house.seasons
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
        # if days_left > 0
        #   days_left -= 1
        #   overlapping_seasons.last[:days] += 1
        # end
      end
      break if year_modifier > 1
    end
    return overlapping_seasons
  end

  def get_seasons_old seasons
    rsy = rs.year #Reservation start year
    rey = rf.year #Reservation end year
    overlapping_seasons = []
    overlapped_info = {}
    year = rsy
    seasons.each do |s|
      ss = Time.parse("#{s.ssd}.#{s.ssm}.#{year}").to_date
      sf = Time.parse("#{s.sfd}.#{s.sfm}.#{year}").to_date
      if rsy == rey
        if ss.month > sf.month
          if overlapping? ss-1.year, sf, rs, rf
            overlapping_seasons.push(get_overlapped_info s.id, ss-1.year, sf, rs, rf)
          end
          if overlapping? ss, sf+1.year, rs, rf
            overlapping_seasons.push(get_overlapped_info s.id, ss, sf+1.year, rs, rf)
          end
        else
          if overlapping? ss, sf, rs, rf
            overlapping_seasons.push(get_overlapped_info s.id, ss, sf, rs, rf)
          end
        end
      elsif rsy < rey
        if ss.month > sf.month
          if overlapping? ss, sf+1.year, rs, rf
            overlapping_seasons.push(get_overlapped_info s.id, ss, sf+1.year, rs, rf)
          end
        else
          if overlapping? ss, sf, rs, rf
            overlapping_seasons.push(get_overlapped_info s.id, ss, sf, rs, rf)
          end
          if overlapping? ss+1.year, sf+1.year, rs, rf
            overlapping_seasons.push(get_overlapped_info s.id, ss+1.year, sf+1.year, rs, rf)
          end
        end
      end
    end
    return overlapping_seasons
  end

  def get_overlapped_info sid, ss, sf, rs, rf
    s = [rs,ss].max
    f = [rf,sf].min
    days = (f.to_date - s.to_date).to_i
    # if re > ss && re < se # Last interval in reservation request
    #   ist = is.strftime("%H:%M")
    #   iet = ie.strftime("%H:%M")
    #   days +=day_change if day_change == 1 && ist < iet
    #   days +=day_change if day_change == -1 && ist > iet
    # end

    hash = { id: sid, days: days , ss: ss, sf: sf }
  end

  def overlapping? (ss, sf, rs, rf)
    if rs < sf && rf > ss
      return true
    else
      return false
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
