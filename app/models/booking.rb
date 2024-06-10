# == Schema Information
#
# Table name: bookings
#
#  id              :bigint           not null, primary key
#  agent           :integer
#  allotment       :boolean          default(FALSE)
#  check_in        :date
#  check_out       :date
#  client_details  :string
#  comm            :integer
#  comment         :text
#  comment_gr      :text
#  comment_owner   :string
#  finish          :date
#  ical_UID        :string
#  ignore_warnings :boolean          default(FALSE)
#  nett            :integer
#  no_check_in     :boolean          default(FALSE)
#  no_check_out    :boolean          default(FALSE)
#  number          :string
#  sale            :integer
#  start           :date
#  status          :integer
#  synced          :boolean          default(FALSE)
#  transfer_in     :boolean          default(FALSE)
#  transfer_out    :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  house_id        :bigint           not null
#  source_id       :integer
#  tenant_id       :bigint
#
# Indexes
#
#  index_bookings_on_house_id   (house_id)
#  index_bookings_on_number     (number) UNIQUE
#  index_bookings_on_source_id  (source_id)
#  index_bookings_on_status     (status)
#  index_bookings_on_synced     (synced)
#  index_bookings_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  bookings_source_id_fk  (source_id => sources.id)
#  fk_rails_...           (house_id => houses.id)
#  fk_rails_...           (tenant_id => users.id)
#
class Booking < ApplicationRecord
  attr_accessor :manual_price, :period

  enum status: {
    temporary: 0,
    pending: 1,
    confirmed: 2,
    paid: 3,
    canceled: 4,
    changing: 5,
    block: 6
  }
  belongs_to :house
  belongs_to :tenant, class_name: 'User', optional: true
  belongs_to :source, optional: true
  has_many :jobs, dependent: :destroy
  has_many :transfers, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :files, dependent: :destroy, class_name: 'BookingFile'
  before_validation :set_dates
  validates :status, :client_details, presence: true
  validate :validate_dates
  validate :price_chain, unless: :allotment?

  scope :active, -> { where.not(status: [:canceled]) }
  scope :for_owner, -> { where.not(status: %i[canceled temporary]).order(:start) }
  scope :real, -> { where.not(status: %i[canceled block]) }
  scope :unpaid, lambda {
                   where.not(status: %i[paid block canceled])
                     .joins(:house)
                     .select('bookings.id', 'bookings.start', 'bookings.finish', 'houses.code', 'owner_id').order('bookings.start')
                 }

  def toggle_status
    return unless %w[block canceled].exclude?(status)

    update(status: 'pending') if transactions.count.zero?
    update(status: 'confirmed') if !fully_paid? && transactions.count >= 1
    update(status: 'paid') if fully_paid?
  end

  def fully_paid?
    return false if status == %w[block canceled]

    income = transactions.joins(:balance_outs).sum(:debit)
    comm = transactions.joins(:balance_outs).sum(:credit)
    to_owner = income - comm
    to_owner == nett && nett != 0
  end

  def self.check_in_out(from = nil, to = nil, type = nil)
    result = []
    if from.blank? && to.blank?
      from = Date.current
      to = Booking.maximum(:finish)
    elsif from.present? && to.blank?
      from = from.to_date
      to = Booking.maximum(:finish)
    elsif from.blank? && to.present?
      from = Date.current
      to = to.to_date
    elsif from.present? && to.present?
      from = from.to_date
      to = to.to_date
    end
    bookings = Booking.active.where('finish >= ? AND start <= ?', from, to).all
    # byebug
    bookings.each do |b|
      next if type == 'Block' && b.status != 'block'

      if  (type == 'All' || type != 'Check out') &&
          ((!b.check_in && b.start >= from && b.start <= to) ||
          (b.check_in && b.check_in >= from && b.check_in <= to))
        line = {}
        line[:booking_id] = b.id
        line[:type] = 'IN'
        line[:date] = b.check_in.present? ? b.check_in.to_fs(:date) : b.start.to_fs(:date)
        line[:transfers] = []
        transfers = b.transfers.where(trsf_type: :IN)
        transfers.each do |t|
          line_in[:transfers] << "#{t.from}-#{t.time} #{t.remarks}"
        end
        line[:status] = b.status
        line[:house] = b.house.code
        line[:client] = b.client_details
        line[:source] = b.source.name if b.source
        line[:comment] = b.comment_gr
        result << line
      end
      next unless (type == 'All' || type != 'Check in') &&
                  ((b.check_out.blank? && b.finish >= from && b.finish <= to) ||
                  (b.check_out.present? && b.check_out >= from && b.check_out <= to))

      line = {}
      line[:booking_id] = b.id
      line[:type] = 'OUT'
      line[:date] = b.check_out.present? ? b.check_out.to_fs(:date) : b.finish.to_fs(:date)
      line[:transfers] = []
      transfers = b.transfers.where(trsf_type: :OUT)
      transfers.each do |t|
        line_out[:transfers] << "#{t.time} #{t.remarks}"
      end
      line[:status] = b.status
      line[:house] = b.house.code
      line[:client] = b.client_details
      line[:source] = b.source.name if b.source
      line[:comment] = b.comment_gr
      result << line

      # unless  b.no_check_in ||
      #         (!b.check_in.present? && b.start < from) ||
      #         (b.check_in.present? && (b.check_in < from || b.check_in > to))
      #   line_in = {}
      #   line_in[:booking_id] = b.id
      #   line_in[:type] = 'IN'
      #   line_in[:status] = b.status
      #   line_in[:date] = b.check_in.present? ? b.check_in.to_fs(:date) : b.start.to_fs(:date)
      #   line_in[:house] = b.house.code
      #   line_in[:client] = b.client_details
      #   line_in[:source] = b.source.name if b.source
      #   line_in[:comment] = b.comment_gr
      #   line_in[:transfers] = []
      #   transfers = b.transfers.where(trsf_type: :IN)
      #   transfers.each do |t|
      #     line_in[:transfers] << "#{t.from}-#{t.time} #{t.remarks}"
      #   end
      #   result << line_in
      # end
      # next if b.no_check_out ||
      #         (!b.check_out.present? && b.finish > to) ||
      #         (b.check_out.present? && (b.check_out < from || b.check_out > to))

      # line_out = {}
      # line_out[:booking_id] = b.id
      # line_out[:type] = 'OUT'
      # line_out[:status] = b.status
      # line_out[:date] = b.check_out.present? ? b.check_out.to_fs(:date) : b.finish.to_fs(:date)
      # line_out[:house] = b.house.code
      # line_out[:client] = b.client_details
      # line_out[:source] = b.source.name if b.source
      # line_out[:comment] = b.comment_gr
      # line_out[:transfers] = []
      # transfers = b.transfers.where(trsf_type: :OUT)
      # transfers.each do |t|
      #   line_out[:transfers] << "#{t.time} #{t.remarks}"
      # end
      # result << line_out
    end
    result.sort_by { |r| r[:date].to_date }
  end

  def self.timeline_data(from = nil, to = nil, period = nil, house_number = nil)
    if from.blank? && to.blank?
      from = Date.current
      if period.nil? && Booking.count.zero?
        period = 45
        to = Date.current + (period.to_i - 1).days
      elsif period.nil? && Booking.count.positive?
        to = Booking.maximum(:finish).to_date
      else
        to = Date.current + (period.to_i - 1).days
      end
    elsif from.present? && to.blank?
      from = from.to_date
      to = Booking.maximum(:finish)
    elsif from.blank? && to.present?
      from = Booking.minimum(:start)
      to = to.to_date
    elsif from.present? && to.present?
      from = from.to_date
      to = to.to_date
    end
    days = (to - from).to_i + 1
    timeline = {}
    # timeline[:start] = today
    timeline[:start] = from
    timeline[:days] = days
    timeline[:houses] = []
    # houses = House.order(:unavailable, :house_group_id, :code)
    houses = if house_number.present?
      House.where(number: house_number).all
    else
      # House.where.not(balance_closed: true, hide_in_timeline: true).order(:unavailable, :house_group_id, :code)
      House.for_timeline
    end
    y = 1
    houses.each do |h|
      # Get bookings for house
      # bookings = h.bookings.where('finish >= ? AND "start" <= ? AND status != ?', today, last_date, Booking.statuses[:canceled]).order(:finish)
      bookings = h.bookings.where('finish >= ? AND "start" <= ? AND status != ?', from, to,
                                  Booking.statuses[:canceled]).order(:finish)
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
        booking[:x] = ([b.start, from].max - from).to_i + 1
        booking[:y] = y
        booking[:length] = ([b.finish, to].min - [b.start, from].max).to_i + 1
        # 14.07.2022: startin - if booking start in timeline frame and need red line style to show start day
        booking[:startsin] = b.start >= from ? 1 : 0
        # 14.07.2022: show brief booking details in tooltip
        source = b.source.name if b.source.present?
        booking[:details] =
          "#{b.start.to_fs(:date)} - #{b.finish.to_fs(:date)} #{b.client_details} #{source}"
        # Get jobs for bookings
        jt_fm = JobType.find_by(name: 'For management').id
        # jobs = b.jobs
        jobs = b.jobs.where.not(job_type_id: jt_fm)
        booking[:jobs] = []
        jobs.each do |j|
          job = {}
          job[:id] = j.id
          job[:type_id] = j.job_type_id
          job[:employee_id] = j.employee.id unless j.employee.nil?
          job[:empl_type_id] = j.employee.type.id unless j.employee.nil?
          # job[:x] = (j.plan - today).to_i+1
          job[:x] = (j.plan - from).to_i + 1
          job[:time] = j.time
          job[:job] = j.job
          job[:comment] = j.comment
          job[:code] = j.job_type.code
          job[:color] = j.job_type.color
          booking[:jobs] << job
        end
        house[:bookings] << booking
      end
      # Get jobs for house
      jt_fm = JobType.find_by(name: 'For management').id
      # jobs = h.jobs
      jobs = h.jobs.where.not(job_type_id: jt_fm).where(booking_id: nil)
      house[:jobs] = []
      jobs.each do |j|
        job = {}
        job[:id] = j.id
        job[:type_id] = j.job_type_id
        job[:employee_id] = j.employee.id unless j.employee.nil?
        job[:empl_type_id] = j.employee.type.id unless j.employee.nil?
        job[:x] = (j.plan - from).to_i + 1 if j.plan.present?
        job[:time] = j.time
        job[:job] = j.job
        job[:comment] = j.comment
        job[:code] = j.job_type.code
        job[:color] = j.job_type.color
        house[:jobs] << job
      end
      timeline[:houses] << house
      y += 1
    end
    timeline
  end

  def calc(price)
    if price.empty?
      self.sale = self.agent = self.nett = self.comm = 0
    else
      self.sale = (price.first[1][:total]).round
      self.agent = 0
      self.nett = (sale * (100 - house.type.comm).to_f / 100).round
      self.comm = (sale - agent - nett).round
    end
  end

  def self.sync(houses = [])
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
                    (e.summary.strip == 'Airbnb (Not available)' ||
                    e.description.nil?)
            next if c.source.name == 'Tripadvisor' &&
                    (e.summary.strip == 'Not available' ||
                    e.description.nil?)
            next if e.dtend < Time.current

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
              synced: true
            )
            search = Search.new(rs: booking.start, rf: booking.finish)
            prices = search.get_prices [h]
            # puts "Event: #{e.inspect}"
            # puts "Search: #{search.inspect}"
            # puts "House: #{h.inspect}"
            booking.calc prices
            booking.save
          end
        rescue OpenURI::HTTPError => e
          response = e.io
          response.status
          # => ["503", "Service Unavailable"]
          response.string
          # => <!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n<html DIR=\"LTR\">\n<head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><meta name=\"viewport\" content=\"initial-scale=1\">...
        end
        c.update(last_sync: Time.current)
      end
    end
  end

  def get_period
    "#{start} - #{finish}" if start.present? && finish.present?
  end

  private

  def set_dates
    return if period.blank?

    self.start = period.split.first.to_date rescue nil
    self.finish = period.split.last.to_date rescue nil
  end

  def validate_dates
    return errors.add(:base, I18n.t("search.dates_not_set")) unless [start, finish].all?(&:present?)

    errors.add(:base, I18n.t("search.rf_less_rs")) if start > finish
  end

  def price_chain
    return unless !block? && (nett != sale - agent - comm)

    errors.add(:base, "Check Prices: Sale - Agent - Comm is not equal to Nett")
  end
end
