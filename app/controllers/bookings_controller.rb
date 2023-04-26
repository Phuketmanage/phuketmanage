class BookingsController < ApplicationController
  load_and_authorize_resource

  before_action :set_booking, only: %i[show edit update
                                       update_comment_gr destroy]
  layout 'admin'

  # @route GET (/:locale)/calendar/ical/:hid (calendar)
  def ical
    cal = Icalendar::Calendar.new
    hid = params[:hid]
    h = House.find_by(number: hid)
    filename = "listing-#{hid}.ics"
    cal.prodid = '-//Phuketmanage.com//Hosting Calendar//EN'
    cal.version = '2.0'
    today = Time.zone.now.in_time_zone('Bangkok').to_date
    except_status = Booking.statuses[:canceled]
    bookings = h.bookings.where(' finish >= :today AND
                                  status != :status',
                                today: today,
                                status: except_status)
      .order(:start).all
    bookings.each do |b|
      cal.event do |e|
        # byebug
        e.dtstart     = Icalendar::Values::Date.new((b.start - 2.days).to_s(:number))
        e.dtend       = Icalendar::Values::Date.new((b.finish + 2.days).to_s(:number))
        e.summary     = "Reserved"
        e.description = "Booking number #{b.number}"
      end
    end
    cal.publish

    send_data cal.to_ical, type: 'text/calendar', disposition: 'inline', filename: filename
    # render :text => cal.to_ical
  end

  # @route GET /bookings (bookings)
  # @route GET (/:locale)/houses/:hid/bookings (house_bookings)
  def index
    @from = params[:from]
    @to = params[:to]
    if (@from.present? && !@to.present?) || (!@from.present? && @to.present?)
      @error = 'Both dates should be selected'
      @bookings = [] and return
    end

    # @oid = params[:oid]
    @hid = params[:hid]

    house_ids = if @hid.present?
      House.where(number: @hid).ids
    elsif @oid.present?
      User.find(@oid).houses.ids
    else
      House.ids
    end
    bookings = Booking.where(house_id: house_ids).all
    if !@from.present? && !@to.present?
      @from = Time.zone.now.in_time_zone('Bangkok').to_date
      @to = if bookings.any?
        bookings.maximum(:finish).in_time_zone('Bangkok').to_date
      else
        @from
      end
    end

    @bookings = bookings.where('finish >= :from AND start <= :to',
                               from: @from, to: @to).order(:start)
  end

  # @route GET /owner/bookings (bookings_front)
  def index_front
    @from = params[:from]
    @to = params[:to]
    if (@from.present? && !@to.present?) || (!@from.present? && @to.present?)
      @error = 'Both dates should be selected'
      @bookings = [] and return
    end

    @hid = params[:hid]
    @oid = params[:oid]
    if @hid.present? && current_user.role?('Admin')
      # Admin look bookings for selected house
      house_ids = House.where(number: @hid).ids
      @oid = House.find_by(number: @hid).owner.id
    elsif @oid.present? && current_user.role?('Admin')
      # Admin look bookings for selected owner
      house_ids = User.find(@oid).houses.ids
    elsif @hid.present? && current_user.houses.where(number: @hid).any?
      # Owner look bookings for selected house
      house_ids = House.where(number: @hid).ids
    else
      # Owner look bookings
      @hid = nil unless current_user.houses.where(number: @hid).any?
      house_ids = current_user.houses.ids
    end
    bookings = Booking.where(house_id: house_ids, status: %w[confirmed block], allotment: false).all

    if !@from.present? && !@to.present?
      @from = Time.zone.now.in_time_zone('Bangkok').to_date
      @to = if bookings.any?
        bookings.maximum(:finish).in_time_zone('Bangkok').to_date
      else
        @from
      end
      @to = @from if @to < @from
    end

    @bookings = bookings.where('(start >= :from AND start <= :to) OR
                                (finish >= :from AND finish <= :to)',
                               from: @from, to: @to).order(:start)
    @one_house = true if current_user.houses.ids.count == 1
  end

  # @route GET /bookings/timeline (bookings_timeline)
  def timeline
    if !params[:from].present? && !params[:to].present?
      @from = Time.zone.now.in_time_zone('Bangkok').to_date
      if params[:period].nil? && Booking.count == 0
        params[:period] = 45
        @to = Time.zone.now.in_time_zone('Bangkok').to_date + (params[:period].to_i - 1).days
      elsif params[:period].nil? && Booking.count > 0
        @to = Booking.maximum(:finish).in_time_zone('Bangkok').to_date
      else
        @to = Time.zone.now.in_time_zone('Bangkok').to_date + (params[:period].to_i - 1).days
      end
    elsif params[:from].present? && !params[:to].present?
      @from = params[:from].to_date
      @to = Booking.maximum(:finish)
    elsif !params[:from].present? && params[:to].present?
      @from = Booking.minimum(:start)
      @to = params[:to].to_date
    elsif params[:from].present? && params[:to].present?
      @from = params[:from].to_date
      @to = params[:to].to_date
    end
    @houses = House.where.not(balance_closed: true, hide_in_timeline: true)
      .order(:unavailable, :house_group_id, :code).all
    @houses_for_select = @houses
    if params[:house_number].present?
      house = params[:house_number]
      @houses = House.where(number: house).all
    end

    @today = @from
    @days = (@to - @from).to_i + 1
    jt_fm = JobType.find_by(name: 'For management').id
    @job_types_for_bookings = JobType.where.not(for_house_only: true, id: jt_fm).order(:name)
    @job_types_for_houses = JobType.where.not(id: jt_fm).order(for_house_only: :desc, name: :asc)
    @job = Job.new
  end

  # @route GET /bookings/timeline_data (bookings_timeline_data)
  def timeline_data
    # puts params[:period].nil?
    timeline = Booking.timeline_data params[:from], params[:to], params[:period], params[:house]
    render json: { timeline: timeline }
  end

  # @route GET /bookings/check_in_out (bookings_check_in_out)
  def check_in_out
    @result = Booking.check_in_out params[:from], params[:to]
  end

  # @route GET /bookings/:id (booking)
  def show
    # booking = Booking.find(params[:id])
    render json: { booking: @booking }
  end

  # @route GET /bookings/new (new_booking)
  # @route GET (/:locale)/houses/:hid/bookings/new (new_house_booking)
  def new
    @booking = Booking.new
    @houses = House.where(unavailable: false).order(:code).map { |h| [h.code, h.id] }
    @booking.house = House.find_by(number: params[:hid]) if params[:hid]
    @tenants = User.with_role('Tenant')
  end

  # @route GET /bookings/:id/edit (edit_booking)
  def edit
    @houses = House.all.order(:code).map { |h| [h.code, h.id] }
    @tenants = User.with_role('Tenant')
    search = Search.new({ rs: @booking.start, rf: @booking.finish })
    @booking_original = nil
    @transfers = @booking.transfers.order(:date)
    @transfer = @booking.transfers.new
    @select_items = House.order(:code).map { |h| [h.code, h.number] }
    @select_items.push('Airport (International)', 'Airport (Domiestic)')
    @booking_file = @booking.files.new
    @s3_direct_post = S3_BUCKET.presigned_post(
      key: "bookings/#{@booking.number}/${filename}",
      success_action_status: '201',
      acl: 'public-read',
      content_type_starts_with: ""
    )
    unless @booking.block?
      @booking_original = @booking.dup
      prices = search.get_prices [@booking.house]
      @booking_original.calc prices
    end
  end

  # @route POST /bookings (bookings)
  def create
    search = Search.new(rs: params[:booking][:start],
                        rf: params[:booking][:finish],
                        dtnb: 0)
    answer = search.is_house_available? @booking.house_id
    unless answer[:result]
      @booking.errors.add(:base,
                          "House is not available for this period, overlapped with bookings: #{answer[:overlapped]}")
      @houses = House.all.order(:code).map { |h| [h.code, h.id] }
      # @tenants = User.with_role('Tenant')
      render :new and return
    end
    if @booking.block?
      @booking.sale = @booking.agent = @booking.comm = @booking.nett = 0
    elsif @booking.manual_price != '1'
      prices = search.get_prices [@booking.house]
      @booking.calc prices
    end
    @booking.number = "#{(('A'..'Z').to_a + ('0'..'9').to_a).sample(7).join}"
    @booking.ical_UID = "#{SecureRandom.hex(16)}@phuketmanage.com"

    respond_to do |format|
      if @booking.save
        hid = House.find(@booking.house_id).number
        format.html { redirect_to bookings_path(hid: hid), notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        @houses = House.all
        # @tenants = User.with_role('Tenant')
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route POST /booking/new (booking_new)
  def create_front
    search = Search.new(rs: params[:booking][:start],
                        rf: params[:booking][:finish],
                        dtnb: @settings['dtnb'])
    house = House.find_by(number: params[:booking][:hid])
    answer = search.is_house_available? house.id
    # byebug
    prices = search.get_prices [house]
    client_details =  "#{params[:booking][:name]} #{params[:booking][:surname]} " +
                      "#{params[:booking][:adult]}+#{params[:booking][:children]}, " +
                      "#{params[:booking][:phone]}, #{params[:booking][:email]}"
    comment = "#{params[:booking][:flight_no]}-#{params[:booking][:flight_time]} / #{params[:booking][:comment]}"
    @booking = house.bookings.new(start: params[:booking][:start],
                                  finish: params[:booking][:finish],
                                  # house_id: house.id,
                                  client_details: client_details,
                                  comment: comment,
                                  status: 'pending')
    @booking.calc prices
    @booking.number = "#{(('A'..'Z').to_a + ('0'..'9').to_a).sample(7).join}"
    @booking.ical_UID = "#{SecureRandom.hex(16)}@phuketmanage.com"
    @booking.save
    BookingMailer.created(@booking).deliver_now
  end

  # @route GET /bookings/sync (booking_sync)
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

  # @route PATCH /bookings/:id (booking)
  # @route PUT /bookings/:id (booking)
  def update
    search = Search.new(rs: params[:booking][:start],
                        rf: params[:booking][:finish],
                        dtnb: 0) # dtnb: @settings['dtnb'])
    house_id = params[:booking][:house_id]
    answer = search.is_house_available? house_id, @booking.id
    unless answer[:result]
      @booking.errors.add(:base,
                          "House is not available for this period, overlapped with bookings: #{answer[:overlapped]}")
      @houses = House.all.order(:code).map { |h| [h.code, h.id] }
      @tenants = User.with_role('Tenant')
      @booking_original = @booking.dup
      prices = search.get_prices [@booking.house]
      @booking_original.calc prices
      @transfers = @booking.transfers.all
      @transfer = @booking.transfers.new
      @select_items = House.order(:code).map { |h| [h.code, h.number] }
      @select_items.push('Airport (International)', 'Airport (Domiestic)')
      render :edit and return
    end

    respond_to do |format|
      if @booking.update(booking_params)
        if  @booking.saved_changes.key?(:start) ||
            @booking.saved_changes.key?(:finish) ||
            @booking.saved_changes.key?(:house_id)
          search = Search.new({ rs: @booking.start,
                                rf: @booking.finish }) # ,
          # staff: true })
          prices = search.get_prices [@booking.house]
          @booking.calc prices
          @booking.save
        end
        hid = House.find(@booking.house_id).number
        format.html { redirect_to bookings_path(hid: hid), notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        @houses = House.all.order(:code).map { |h| [h.code, h.id] }
        @tenants = User.with_role('Tenant')
        @booking_original = @booking.dup
        search = Search.new({ rs: @booking.start, rf: @booking.finish })
        prices = search.get_prices [@booking.house]
        @booking_original.calc prices
        @transfers = @booking.transfers.all
        @transfer = @booking.transfers.new
        @select_items = House.order(:code).map { |h| [h.code, h.number] }
        @select_items.push('Airport (International)', 'Airport (Domiestic)')
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /bookings/:id/update_comment_gr (update_booking_comment_gr)
  def update_comment_gr
    @booking.update(booking_params)
    @result = Booking.check_in_out
    redirect_to bookings_check_in_out_path
  end

  # @route DELETE /bookings/:id (booking)
  def destroy
    @booking.destroy
    respond_to do |format|
      path = if params[:hid]
        house_bookings_path(@booking.house.number)
      else
        bookings_path
      end
      format.html { redirect_to path, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # @route GET /bookings/get_price (bookings_get_price)
  def get_price
    booking = Booking.new
    search = Search.new(rs: params[:start],
                        rf: params[:finish],
                        dtnb: 0)
    booking.house = House.find(params[:house_id])
    prices = search.get_prices [booking.house]
    booking.calc prices
    render json: { sale: booking.sale, comm: booking.comm, nett: booking.nett }
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
                                    :check_out,
                                    :paid,
                                    :ignore_warnings,
                                    :manual_price)
  end
end
