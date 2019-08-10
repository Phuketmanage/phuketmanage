class Booking < ApplicationRecord

  enum status:  {
    temporary: 0,
    pending: 1,
    confirmed: 2,
    paid: 3,
    canceled: 4,
    changing: 5,
    block: 6 }
  belongs_to :house
  belongs_to :tenant, class_name: 'User', optional: true
  belongs_to :source, optional: true
  has_many :jobs, dependent: :destroy
  has_many :transfers, dependent: :destroy
  validate :price_chain, unless: :allotment?

  scope :active, -> { where.not(status: [:canceled]) }
  scope :real, -> { where.not(status: [:canceled, :block]) }

  def self.check_in_out from = nil, to = nil
    result = []
    if !from.present? && !to.present?
      from = Time.zone.now.in_time_zone('Bangkok').to_date
      to = Booking.maximum(:finish)
      # bookings = Booking.real.where('finish >= ?', today).all
    elsif from.present? && !to.present?
      from = from.to_date
      to = Booking.maximum(:finish)
      # bookings = Booking.real.where('finish >= ? AND start <= ?', from, today).all
    elsif !from.present? && to.present?
      from = Time.zone.now.in_time_zone('Bangkok').to_date
      to = to.to_date
      # bookings = Booking.real.where('finish >= ? AND start <= ?', from, today).all
    elsif from.present? && to.present?
      from = from.to_date
      to = to.to_date
      # bookings = Booking.real.where('finish >= ? AND start <= ?', from, to).all
    end
    bookings = Booking.real.where('finish >= ? AND start <= ?', from, to).all
    # today = Time.zone.now.in_time_zone('Bangkok').to_date
    # bookings = Booking.real.where('finish >= ?', today).all
    bookings.each do |b|
      # puts "#{!b.check_in.present?} && #{b.start} < #{from}"
      unless  b.no_check_in ||
              (!b.check_in.present? && b.start < from) ||
              (b.check_in.present? && (b.check_in < from || b.check_in > to))
        puts b.no_check_in
        puts "#{!b.check_in.present?} && #{b.start} < #{from}"
        puts "#{b.check_in.present?} && #{b.check_in} < #{from}"
        line_in = {}
        line_in[:booking_id] = b.id
        line_in[:type] = 'IN'
        line_in[:date] = b.check_in.present? ? b.check_in.strftime('%d.%m.%Y') : b.start.strftime('%d.%m.%Y')
        line_in[:house] = b.house.code
        line_in[:client] = b.client_details
        line_in[:source] = b.source.name if b.source
        line_in[:comment] = b.comment_gr
        line_in[:transfers] = []
        transfers = b.transfers.where(trsf_type: :IN)
        transfers.each do |t|
          line_in[:transfers] << "#{t.from}-#{t.time} #{t.remarks}"
        end
        result << line_in
      end
      unless  b.no_check_out ||
              (!b.check_out.present? && b.finish > to) ||
              (b.check_out.present? && (b.check_out < from || b.check_out > to))
        line_out = {}
        line_out[:booking_id] = b.id
        line_out[:type] = 'OUT'
        line_out[:date] = b.check_out.present? ? b.check_out.strftime('%d.%m.%Y') : b.finish.strftime('%d.%m.%Y')
        line_out[:house] = b.house.code
        line_out[:client] = b.client_details
        line_out[:source] = b.source.name if b.source
        line_out[:comment] = b.comment_gr
        line_out[:transfers] = []
        transfers = b.transfers.where(trsf_type: :OUT)
        transfers.each do |t|
          line_out[:transfers] << "#{t.time} #{t.remarks}"
        end
        result << line_out
      end
    end
    result.sort_by{|r| r[:date].to_date}
  end

  def self.timeline_data period = nil
    today = Time.zone.now.in_time_zone('Bangkok').to_date
    if period.nil?
      last_date = Booking.maximum(:finish).in_time_zone('Bangkok').to_date
    else
      last_date = Time.zone.now.in_time_zone('Bangkok').to_date + (period.to_i-1).days
    end
    days = (last_date - today).to_i+1
    timeline = {}
    timeline[:start] = today
    timeline[:days] = days
    timeline[:houses] = []
    houses = House.order(:unavailable, :code)
    y = 1
    houses.each do |h|
      # Get bookings for house
      bookings = h.bookings.where('finish >= ? AND "start" <= ? AND status != ?', today, last_date, Booking.statuses[:canceled]).order(:finish)
      house = {}
      house[:hid] = h.number
      house[:y] = y
      house[:bookings] = []
      bookings.each do |b|
        booking = {}
        booking[:id] = b.id
        booking[:number] = b.number
        booking[:status] = b.status
        booking[:comment] = b.comment
        booking[:x] = ([b.start, today].max - today).to_i+1
        booking[:y] = y
        booking[:length] = ([b.finish, last_date].min-[b.start, today].max).to_i+1
        # Get jobs for bookings
        jobs = b.jobs

        booking[:jobs] = []
        jobs.each do |j|
          job = {}
          job[:id] = j.id
          job[:type_id] = j.job_type_id
          job[:employee_id] = j.employee.id if !j.employee.nil?
          job[:empl_type_id] = j.employee.type.id if !j.employee.nil?
          job[:x] = (j.plan - today).to_i+1
          job[:time] = j.time
          job[:comment] = j.comment
          job[:code] = j.job_type.code
          job[:color] = j.job_type.color
          booking[:jobs] << job
        end
        house[:bookings] << booking
      end
      # Get jobs for house
      jobs = h.jobs
      house[:jobs] = []
      jobs.each do |j|
        job = {}
        job[:id] = j.id
        job[:type_id] = j.job_type_id
        job[:employee_id] = j.employee.id if !j.employee.nil?

        job[:empl_type_id] = j.employee.type.id if !j.employee.nil?
        job[:x] = (j.plan - today).to_i+1
        job[:time] = j.time
        job[:comment] = j.comment
        job[:code] = j.job_type.code
        job[:color] = j.job_type.color
        house[:jobs] << job
      end
      timeline[:houses] << house
      y += 1
    end
    return timeline
  end

  def calc price
    if price.empty?
      self.sale = self.agent = self.nett = self.comm = 0
    else
      self.sale = (price.first[1][:total]).round()
      self.agent = 0
      self.nett = (sale * (100-house.type.comm).to_f/100).round()
      self.comm = (sale - agent - nett).round()
    end
  end

  def self.sync houses = []
    require 'open-uri'
    houses = House.all if houses.empty?
    houses.each do |h|
      # h.bookings.where('source_id IS NOT NULL AND number IS NULL').destroy_all
      h.bookings.where(synced: true).destroy_all
      connections = h.connections
      connections.each do |c|
        begin
          cal_file = open(c.link)
          cals = Icalendar::Calendar.parse(cal_file)
          cal = cals.first
          # if c.source.name == 'Tripadvisor'

          # end

          cal.events.each do |e|
            # #Airbnb specific: If date was blocked  few days before and
            # # after booking
            next if c.source.name == 'Airbnb' &&
                    ( e.summary.strip == 'Airbnb (Not available)' ||
                    e.description.nil? )
            next if c.source.name == 'Tripadvisor' &&
                    ( e.summary.strip == 'Not available' ||
                    e.description.nil? )
            next if e.dtend < Time.zone.now
            # #Airbnb, Homeaway: Check if booking was synced before
            # if  c.source.name == 'Airbnb' ||
            #     c.source.name == 'Homeaway' ||
            #     c.source.name == 'Booking'
            #   existing_booking = h.bookings.where(ical_UID: e.uid.to_s).first
            #   if !existing_booking.nil?
            #     #If booking was synced before and didn't changed
            #     next if existing_booking.start == e.dtstart &&
            #             existing_booking.finish == e.dtend &&
            #             existing_booking.comment == "#{e.summary} \n #{e.description}"
            #     #If booking was synced before but was changed need to rewrite
            #     existing_booking.destroy
            #     # Here need to add notification
            #     # Notification.new( type: Booking,
            #     #                   comment: 'Updated after sync',
            #     #                   link: link_to booking_path())
            #   end
            # end

            booking = h.bookings.new(
                                    number: nil,
                                    source_id: c.source_id,
                                    start: e.dtstart,
                                    finish: e.dtend,
                                    ical_UID: e.uid,
                                    comment: "#{e.summary} \n #{e.description}",
                                    synced: true)
            search = Search.new(rs: booking.start, rf: booking.finish)
            prices = search.get_prices [h]
            # puts "Event: #{e.inspect}"
            # puts "Search: #{search.inspect}"
            # puts "House: #{h.inspect}"
            booking.calc prices
            booking.save
          end
        rescue OpenURI::HTTPError => error
          response = error.io
          response.status
          # => ["503", "Service Unavailable"]
          response.string
          # => <!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n<html DIR=\"LTR\">\n<head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><meta name=\"viewport\" content=\"initial-scale=1\">...
        end
        c.update(last_sync: Time.zone.now)
      end
    end
  end

  private

    def price_chain
      if !self.block?
        if nett != sale - agent - comm
          errors.add(:base, "Check Prices: Sale - Agent - Comm is not equal to Nett")
        end
      end
    end

end
