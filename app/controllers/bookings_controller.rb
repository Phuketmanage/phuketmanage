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
    if !params[:hid].present?
      if !params[:past].present? #when
        @bookings = Booking.where('finish >= ?', Time.zone.now.to_date).order(:start)
      else
        @bookings = Booking.where('finish < ?', Time.zone.now.to_date).order(:start)
      end
    else
      @house = House.find_by(number: params[:hid])
      if !params[:past].present? #when
        @bookings = @house.bookings.where('finish >= ?', Time.zone.now.to_date).order(:start)
      else
        @bookings = @house.bookings.where('finish < ?', Time.zone.now.to_date).order(:start)
      end
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
    if params[:hid]
      @booking.house = @houses.find_by(number: params[:hid])
    end

    @tenants = User.with_role('Tenant')

  end

  # GET /bookings/1/edit
  def edit
    @houses = House.all.active
    @tenants = User.with_role('Tenant')
    search = Search.new({rs: @booking.start, rf: @booking.finish})
    @booking_original = nil
    unless @booking.block?
      @booking_original = @booking.dup
      prices = search.get_prices [@booking.house]
      @booking_original.calc prices.first[1]
    end
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
    if @booking.block?
      @booking.sale = @booking.agent = @booking.comm = @booking.nett = 0
    else
      prices = search.get_prices [@booking.house]
      @booking.calc prices.first[1]
    end
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
    if params[:hid].present?
      house = House.find_by(number: params[:hid])
      # bookings = house.bookings.order(:start)
      Booking.sync [house]
      redirect_to house_bookings_path(house.number) and return
    else
      Booking.sync
      redirect_to bookings_path and return
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
      if params[:hid]
        path = house_bookings_path(@booking.house.number)
      else
        path = bookings_path
      end
      format.html { redirect_to path, notice: 'Booking was successfully destroyed.' }
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
      params.require(:booking).permit(:start, :finish, :house_id, :tenant_id, :number, :ical_UID, :source_id, :sale, :agent, :comm, :nett, :status, :comment)
    end


end
