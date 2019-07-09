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
    if !params[:house_id].present?
      @bookings = Booking.all.order(:start)
    else
      @house = House.find_by(number: params[:house_id])
      @house.connections.each do |c|
        sync @house, c
      end
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
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)
    @booking.number = "#{(('A'..'Z').to_a+('0'..'9').to_a).shuffle[0..6].join}"
    @booking.ical_UID = "#{SecureRandom.hex(16)}@phuketmanage.com"
    respond_to do |format|
      if @booking.save
        format.html { redirect_to bookings_path, notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        @houses = House.all.active
        @tenants = User.with_role('Tenant')
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to bookings_path, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        @houses = House.all.active
        @tenants = User.with_role('Tenant')
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
      params.require(:booking).permit(:start, :finish, :house_id, :tenant_id, :number, :ical_UID, :source_id)
    end

    def sync house, connection
      house.bookings.where(source_id: connection.source_id).destroy_all
      require 'open-uri'
      begin
        cal_file = open(connection.link)
        cals = Icalendar::Calendar.parse(cal_file)
        cal = cals.first

        cal.events.each do |e|
          house.bookings.create!( source_id: connection.source_id,
                                  start: e.dtstart,
                                  finish: e.dtend,
                                  ical_UID: e.uid,
                                  comment: "#{e.summary} \n #{e.description}")
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
