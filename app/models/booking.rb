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
  validate :price_chain

  def self.prepare_timeline today, last_date
    days = (last_date - today).to_i+1
    timeline_data = {}

    houses = House.order(unavailable: :asc).select(:id)
    houses.each do |h|
      bookings = h.bookings.where('finish >= ? AND "start" <= ? AND status != ?', today, last_date, Booking.statuses[:canceled]).order(:finish)
      timeline_data[h.id] = {}
      timeline_data[h.id]['tmp_house'] = h.code
      timeline_data[h.id]['tmp_today'] = today
      timeline_data[h.id]['tmp_last_date'] = last_date
      index = 0
      last_cell = 0
      bookings.each do |b|
        index += 1
        timeline_data[h.id][b.id] = {}
        if b.start < today
          empty_cells = 0
          booking_cells = (b.finish - today).to_i+1
        else
          empty_cells = (b.start - today).to_i-last_cell
          booking_cells = (b.finish - cb.start).to_i+1
          # over_cells = last_cell+empty_cells+booking_cells - @days*2
          # over_cells - 0.5 if over_cells % 2 > 0
          # booking_cells -= over_cells if over_cells > 0
        end

        timeline_data[h.id][b.id][:tmp_period] = "#{b.start} - #{b.finish}"
        timeline_data[h.id][b.id][:empty_cells] = empty_cells
        timeline_data[h.id][b.id][:booking_cells] = booking_cells
        timeline_data[h.id][b.id][:class] = b.status
        last_cell += empty_cells + booking_cells
        timeline_data[h.id][b.id][:last_cell] = last_cell
        if bookings.count(:id) == index
          empty_cells = days - last_cell +1
          timeline_data[h.id][0] = {}
          timeline_data[h.id][0][:empty_cells] = empty_cells
          timeline_data[h.id][0][:booking_cells] = 0
        end
      end
      if bookings.empty?
        timeline_data[h.id][0] = {}
        timeline_data[h.id][0][:empty_cells] = days
        timeline_data[h.id][0][:booking_cells] = 0
      end
    end
    return timeline_data
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
