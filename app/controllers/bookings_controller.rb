class BookingsController < ApplicationController
  load_and_authorize_resource

  before_action :set_booking, only: [ :show, :edit, :update,
                                      :update_comment_gr,  :destroy ]
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
    @from = params[:from]
    @to = params[:to]
    if (@from.present? && !@to.present?) || (!@from.present? && @to.present?)
      @error = 'Both dates should be selected'
      @bookings = [] and return
    end

    @hid = params[:hid]
    if @hid.present?
      house_ids = House.where(number: params[:hid]).ids
    else
      house_ids = House.ids
    end
    bookings = Booking.where(house_id: house_ids).all

    if !@from.present? && !@to.present?
      @from = Time.zone.now.in_time_zone('Bangkok').to_date
      if bookings.any?
        @to = bookings.maximum(:finish).in_time_zone('Bangkok').to_date
      else
        @to = @from
      end
    end
    @bookings = bookings.where(' (start >= :from AND start <= :to) OR
                                (finish >= :from AND finish <= :to)',
                                from: @from, to: @to).order(:start)
  end

  def index_front
    @from = params[:from]
    @to = params[:to]
    if (@from.present? && !@to.present?) || (!@from.present? && @to.present?)
      @error = 'Both dates should be selected'
      @bookings = [] and return
    end

    @hid = params[:hid]
    if params[:hid].present?
      house_ids = House.where(number: params[:hid]).ids
    else
      house_ids = current_user.houses.ids
    end
    bookings = Booking.where(house_id: house_ids, status: ['confirmed', 'block']).all

    if !@from.present? && !@to.present?
      @from = Time.zone.now.in_time_zone('Bangkok').to_date
      if bookings.any?
        @to = bookings.maximum(:finish).in_time_zone('Bangkok').to_date
      else
        @to = @from
      end
    end
    @bookings = bookings.where('(start >= :from AND start <= :to) OR
                                (finish >= :from AND finish <= :to)',
                                from: @from, to: @to).order(:start)
    @one_house = true if current_user.houses.ids.count == 1
  end

  def timeline
    if !params[:from].present? && !params[:to].present?
      from = Time.zone.now.in_time_zone('Bangkok').to_date
      if params[:period].nil?
        to = Booking.maximum(:finish).in_time_zone('Bangkok').to_date
      else
        to = Time.zone.now.in_time_zone('Bangkok').to_date + (params[:period].to_i-1).days
      end
    elsif params[:from].present? && !params[:to].present?
      from = params[:from].to_date
      to = Booking.maximum(:finish)
    elsif !params[:from].present? && params[:to].present?
      from = Booking.minimum(:start)
      to = params[:to].to_date
    elsif params[:from].present? && params[:to].present?
      from = params[:from].to_date
      to = params[:to].to_date
    end
    @houses = House.order(:unavailable, :code)
    @today = from
    @days = (to - from).to_i+1
    @job_types_for_bookings = JobType.where.not(for_house_only: true).order(:name)
    @job_types_for_houses = JobType.order(for_house_only: :desc, name: :asc)
    @job = Job.new
  end

  def timeline_data
    # puts params[:period].nil?
    # byebug
    timeline = Booking.timeline_data params[:from], params[:to], params[:period]
    render json: { timeline:  timeline }
  end

  def check_in_out
    @result = Booking.check_in_out params[:from], params[:to]
  end


  # GET /bookings/1
  # GET /bookings/1.json
  def show
    # booking = Booking.find(params[:id])
    render json: { booking:  @booking }
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @houses = House.all
    if params[:hid]
      @booking.house = @houses.find_by(number: params[:hid])
    end
    @tenants = User.with_role('Tenant')
  end

  # GET /bookings/1/edit
  def edit
    @houses = House.all
    @tenants = User.with_role('Tenant')
    search = Search.new({rs: @booking.start, rf: @booking.finish})
    @booking_original = nil
    @transfers = @booking.transfers.order(:date)
    @transfer = @booking.transfers.new
    @select_items = House.order(:code).map{|h| [h.code, h.number]}
    @select_items.push(*['Airport (International)', 'Airport (Domiestic)'])
    # @transfers_in = @booking.transfers.where(trsf_type: 'IN')
    # @transfers_out = @booking.transfers.where(trsf_type: 'OUT')
    unless @booking.block?
      @booking_original = @booking.dup
      prices = search.get_prices [@booking.house]
      @booking_original.calc prices
    end
  end

  # POST /bookings
  # POST /bookings.json
  def create
    # byebug
    search = Search.new( rs: params[:booking][:start],
                          rf: params[:booking][:finish],
                          dtnb: 0)
    answer = search.is_house_available? @booking.house_id
    # byebug
    if !answer[:result]
      if controller_name == 'houses'
      end
      @booking.errors.add(:base, "House is not available for this period, overlapped with bookings: #{answer[:overlapped]}")
      @houses = House.all
      # @tenants = User.with_role('Tenant')
      render :new and return
    end
    if @booking.block?
      @booking.sale = @booking.agent = @booking.comm = @booking.nett = 0
    else
      prices = search.get_prices [@booking.house]
      @booking.calc prices
    end
    @booking.number = "#{(('A'..'Z').to_a+('0'..'9').to_a).shuffle[0..6].join}"
    @booking.ical_UID = "#{SecureRandom.hex(16)}@phuketmanage.com"

    respond_to do |format|
      if @booking.save
        format.html { redirect_to edit_booking_path(@booking), notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        @houses = House.all
        # @tenants = User.with_role('Tenant')
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_front
    search = Search.new( rs: params[:booking][:start],
                          rf: params[:booking][:finish],
                          dtnb: @settings['dtnb'])
    house = House.find_by(number: params[:booking][:hid])
    answer = search.is_house_available? house.id
    # byebug
    prices = search.get_prices [house]
    client_details =  "#{params[:booking][:name]} #{params[:booking][:surname]} "+
                      "#{params[:booking][:adult]}+#{params[:booking][:children]}, "+
                      "#{params[:booking][:phone]}, #{params[:booking][:email]}"
    comment = "#{params[:booking][:flight_no]}-#{params[:booking][:flight_time]} / #{params[:booking][:comment]}"
    @booking = house.bookings.new( start: params[:booking][:start],
                            finish: params[:booking][:finish],
                            # house_id: house.id,
                            client_details: client_details,
                            comment: comment,
                            status: 'pending')
    @booking.calc prices
    @booking.number = "#{(('A'..'Z').to_a+('0'..'9').to_a).shuffle[0..6].join}"
    @booking.ical_UID = "#{SecureRandom.hex(16)}@phuketmanage.com"
    @booking.save
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
                        dtnb: 0) #dtnb: @settings['dtnb'])
    house_id = params[:booking][:house_id]
    answer = search.is_house_available? house_id, @booking.id
    if !answer[:result]
      @booking.errors.add(:base, "House is not available for this period, overlapped with bookings: #{answer[:overlapped]}")
      @houses = House.all
      @tenants = User.with_role('Tenant')
      @booking_original = @booking.dup
      prices = search.get_prices [@booking.house]
      @booking_original.calc prices
      @transfers = @booking.transfers.all
      @transfer = @booking.transfers.new
      @select_items = House.order(:code).map{|h| [h.code, h.number]}
      @select_items.push(*['Airport (International)', 'Airport (Domiestic)'])
      render :edit and return
    end


    respond_to do |format|
      if @booking.update(booking_params)
        if  @booking.saved_changes.key?(:start) ||
            @booking.saved_changes.key?(:finish) ||
            @booking.saved_changes.key?(:house_id)
            search = Search.new({ rs: @booking.start,
                                  rf: @booking.finish}) #,
                                  # staff: true })
            prices = search.get_prices [@booking.house]
            @booking.calc prices
            @booking.save
        end
        format.html { redirect_to edit_booking_path(@booking), notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        @houses = House.all
        @tenants = User.with_role('Tenant')
        @booking_original = @booking.dup
        search = Search.new({rs: @booking.start, rf: @booking.finish})
        prices = search.get_prices [@booking.house]
        @booking_original.calc prices
        @transfers = @booking.transfers.all
        @transfer = @booking.transfers.new
        @select_items = House.order(:code).map{|h| [h.code, h.number]}
        @select_items.push(*['Airport (International)', 'Airport (Domiestic)'])
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_comment_gr
    @booking.update(booking_params)
    @result = Booking.check_in_out
    redirect_to bookings_check_in_out_path
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
      params.require(:booking).permit(:start,
                                      :finish,
                                      :house_id,
                                      :tenant_id,
                                      :number,
                                      :ical_UID,
                                      :source_id,
                                      :sale,
                                      :agent,
                                      :comm,
                                      :nett,
                                      :status,
                                      :comment,
                                      :comment_gr,
                                      :comment_owner,
                                      :allotment,
                                      :in_details,
                                      :out_details,
                                      :transfer_in,
                                      :transfer_out,
                                      :client_details,
                                      :no_check_in,
                                      :no_check_out,
                                      :check_in,
                                      :check_out )
    end


end
