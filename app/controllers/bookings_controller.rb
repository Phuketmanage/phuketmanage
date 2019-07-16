class BookingsController < ApplicationController
  load_and_authorize_resource

  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def ical
    require 'icalendar'
    @cal = Icalendar::Calendar.new
    @cal.NAME = 'Awesome Rails Calendar'
    @cal.x_wr_calname = 'Awesome Rails Calendar'
    @cal.event do |e|
      e.dtstart     = DateTime.now + 2.days
      e.dtend       = DateTime.now + 20.days
      e.summary     = "Meeting with the man."
      e.description = "Have a long lunch meeting and decide nothing..."
    end
    @cal.publish

    respond_to do |format|
      # byebug
        format.html do
          render plain: @cal.to_ical
        end
        format.ics do
          render plain: @cal.to_ical
        end
    end
  end

  # GET /bookings
  # GET /bookings.json
  def index
    if !params[:number].present?
      @bookings = Booking.all.order(:start)
    else
      @house = House.find_by(number: params[:number])
      @bookings = @house.bookings.order(:start)
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @houses = House.all.active
    @tenants = User.with_role('Tenant')
  end

  # GET /bookings/1/edit
  def edit
    @houses = House.all.active
    @tenants = User.with_role('Tenant')
    @booking_original = @booking.dup
    search = Search.new({rs: @booking.start, rf: @booking.finish})
    prices = search.get_prices [@booking.house]
    @booking_original.calc prices.first[1]
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)
    search = Search.new(rs: @booking.start,
                        rf: @booking.finish,
                        dtnb: @settings['dtnb'])
    answer = search.is_house_available? @booking.house_id
    if !answer[:result]
      @booking.errors.add(:base, "House is not available for this period, overlapped with bookings: #{answer[:overlapped]}")
      @houses = House.all.active
      @tenants = User.with_role('Tenant')
      render :new and return
    end
    @booking = Booking.new(booking_params)
    prices = search.get_prices [@booking.house]
    @booking.calc prices.first[1]
    @booking.number = "#{(('A'..'Z').to_a+('0'..'9').to_a).shuffle[0..6].join}"
    @booking.ical_UID = "#{SecureRandom.hex(16)}@phuketmanage.com"
    respond_to do |format|
      if @booking.save
        format.html { redirect_to edit_booking_path(@booking), notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        @houses = House.all.active
        @tenants = User.with_role('Tenant')
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def sync

    if params[:a] == 'update'
      if !params[:number].present?
        redirect_to bookings_path
      else
        house = House.find_by(number: params[:number])
        connections = house.connections
        connections.each do |c|
          next if c.source_id == 1 || c.source_id == 2 || c.source_id == 3
          # Check if was never synced
          what_to_sync = 'upcoming'
          what_to_sync = 'all' if c.last_sync.nil?
          get_synced_data house, c, what_to_sync
          c.update_attributes(last_sync: Time.zone.now)
        end
        bookings = house.bookings.order(:start)
        redirect_to house_bookings_path(house.number)
      end
    elsif params[:a] == 'clear'
      house = House.find_by(number: params[:number])

      house.bookings.where.not(source_id: nil).destroy_all
      house.connections.update_all(last_sync: nil)
      redirect_to house_bookings_path(house.number)
    end

  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    search = Search.new(rs: params[:booking][:start],
                        rf: params[:booking][:finish],
                        dtnb: @settings['dtnb'])
    house_id = params[:booking][:house_id]
    answer = search.is_house_available? house_id, @booking.id
    if !answer[:result]
      @booking.errors.add(:base, "House is not available for this period, overlapped with bookings: #{answer[:overlapped]}")
      @houses = House.all.active
      @tenants = User.with_role('Tenant')
      @booking_original = @booking.dup
      prices = search.get_prices [@booking.house]
      @booking_original.calc prices.first[1]
      render :edit and return
    end


    respond_to do |format|
      if @booking.update(booking_params)
        if  @booking.saved_changes.key?(:start) ||
            @booking.saved_changes.key?(:finish) ||
            @booking.saved_changes.key?(:house_id)
            search = Search.new({rs: @booking.start, rf: @booking.finish})
            prices = search.get_prices [@booking.house]
            @booking.calc prices.first[1]
            @booking.save
        end
        format.html { redirect_to edit_booking_path(@booking), notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        @houses = House.all.active
        @tenants = User.with_role('Tenant')
        @booking_original = @booking.dup
        search = Search.new({rs: @booking.start, rf: @booking.finish})
        prices = search.get_prices [@booking.house]
        @booking_original.calc prices.first[1]
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:start, :finish, :house_id, :tenant_id, :number, :ical_UID, :source_id, :sale, :agent, :comm, :nett)
    end

    def get_synced_data house, connection, what_to_sync
      # house.bookings.where(source_id: connection.source_id).destroy_all
      require 'open-uri'
      begin
        cal_file = open(connection.link)
        cals = Icalendar::Calendar.parse(cal_file)
        cal = cals.first
        if connection.source.name == 'Tripadvisor'
          house.bookings.where(source_id: connection.source_id).destroy_all
        end
        cal.events.each do |e|

          #Airbnb specific: If date was blocked  few days before and
          # after booking
          next if connection.source.name == 'Airbnb' &&
                  ( e.summary.strip == 'Airbnb (Not available)' ||
                  e.description.nil? )
          next if what_to_sync == 'upcoming' &&
                  e.dtend < Time.zone.now
          #Airbnb, Homeaway: Check if booking was synced before
          if  connection.source.name == 'Airbnb' ||
              connection.source.name == 'Homeaway' ||
              connection.source.name == 'Booking'
            existing_booking = house.bookings.where(ical_UID: e.uid.to_s).first
            if !existing_booking.nil?
              #If booking was synced before and didn't changed
              next if existing_booking.start == e.dtstart &&
                      existing_booking.finish == e.dtend &&
                      existing_booking.comment == "#{e.summary} \n #{e.description}"
              #If booking was synced before but was changed need to rewrite
              existing_booking.destroy
              # Here need to add notification
              # Notification.new( type: Booking,
              #                   comment: 'Updated after sync',
              #                   link: link_to booking_path())
            end
          end
          #Tripadvisor: Check if booking was synced before

          booking = house.bookings.new(
                                  source_id: connection.source_id,
                                  start: e.dtstart,
                                  finish: e.dtend,
                                  ical_UID: e.uid,
                                  comment: "#{e.summary} \n #{e.description}")
          search = Search.new({rs: booking.start, rf: booking.finish})
          prices = search.get_prices booking.house
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
    end

end
