class Admin::BookingsController < AdminController
  load_and_authorize_resource

  before_action :set_booking, only: %i[show edit update
                                       update_comment_gr destroy]

  # @route GET /calendar/ical/:hid (calendar)
  def ical
    cal = Icalendar::Calendar.new
    hid = params[:hid]
    h = House.find_by(number: hid)
    filename = "listing-#{hid}.ics"
    cal.prodid = '-//Phuketmanage.com//Hosting Calendar//EN'
    cal.version = '2.0'
    today = Date.current
    except_status = Booking.statuses[:canceled]
    bookings = h.bookings.where(' finish >= :today AND
                                  status != :status',
                                today:,
                                status: except_status)
      .order(:start).all
    bookings.each do |b|
      cal.event do |e|
        e.dtstart     = Icalendar::Values::Date.new((b.start - 2.days).to_s(:number))
        e.dtend       = Icalendar::Values::Date.new((b.finish + 2.days).to_s(:number))
        e.summary     = "Reserved"
        e.description = "Booking number #{b.number}"
      end
    end
    cal.publish

    send_data cal.to_ical, type: 'text/calendar', disposition: 'inline', filename:
  end

  # @route GET /admin_houses/:admin_house_id/bookings (admin_house_bookings)
  # @route GET /bookings (bookings)
  def index
    @from, @to, @error = set_period(params)
    flash[:alert] = @error if @error
    @hid = params[:admin_house_id] || params[:hid]
    @view_as_owner = params[:view_as_owner].present? ? true : false
    @houses = set_houses
    @bookings = Booking.active.where('finish >= :from AND start <= :to', from: @from, to: @to).order(:start)
    return unless @hid.present?

    @bookings = @bookings.where(house_id: @hid)
  end

  # @route GET /bookings/canceled (canceled_bookings)
  def canceled
    @from, @to, @error = set_period(params)
    flash[:alert] = @error if @error
    @hid = params[:hid]
    @houses = set_houses
    @bookings = Booking.canceled.where('finish >= :from AND start <= :to', from: @from, to: @to).order(:start)
    return unless @hid.present?

    @bookings = @bookings.where(house_id: @hid)
  end

  # @route GET /owner/bookings (bookings_front)
  def index_front
    @from, @to, @error = set_period(params)
    flash[:alert] = @error if @error
    @hid = params[:hid]
    @houses = set_houses
    house_ids = current_user.houses.ids
    @bookings = Booking.for_owner.where(finish: @from.., start: ..@to, house_id: house_ids, allotment: false)
    @bookings = @bookings.where(house_id: @hid) if @hid.present?
    @one_house = true if current_user.houses.ids.count == 1
  end

  # @route GET /bookings/timeline (timeline_bookings)
  def timeline
    if !params[:from].present? && !params[:to].present?
      @from = Date.current
      if params[:period].nil? && Booking.count == 0
        params[:period] = 45
        @to = Date.current + (params[:period].to_i - 1).days
      elsif params[:period].nil? && Booking.count > 0
        @to = Booking.maximum(:finish).to_date
      else
        @to = Date.current + (params[:period].to_i - 1).days
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
    @houses = House.for_timeline
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

  # @route GET /bookings/timeline_data (timeline_data_bookings)
  def timeline_data
    timeline = Booking.timeline_data params[:from], params[:to], params[:period], params[:house]
    render json: { timeline: }
  end

  # @route GET /bookings/check_in_out (check_in_out_bookings)
  def check_in_out
    @type = (params[:commit].presence || 'All')
    @result = Booking.check_in_out params[:from], params[:to], @type
  end

  # @route GET /bookings/:id (booking)
  def show
    render json: { booking: @booking }
  end

  # @route GET /admin_houses/:admin_house_id/bookings/new (new_admin_house_booking)
  # @route GET /bookings/new (new_booking)
  def new
    @booking = Booking.new
    @houses = House.where(unavailable: false).order(:code).map { |h| [h.code, h.id] }
    @booking.house = House.find_by(id: params[:admin_house_id]) if params[:admin_house_id]
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

    return if @booking.block?

    @booking_original = @booking.dup
    prices = search.get_prices [@booking.house]
    @booking_original.calc prices
  end

  # @route POST /bookings (bookings)
  def create
    search = Search.new(period: search_params, dtnb: 0)
    answer = search.is_house_available? @booking.house_id
    unless answer[:result]
      @booking.errors.add(:base,
                          "House is not available for this period, overlapped with bookings: #{answer[:overlapped]}")
      @houses = House.all.order(:code).map { |h| [h.code, h.id] }
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
        format.html do
          redirect_to admin_house_bookings_path(@booking.house_id), notice: 'Booking was successfully created.'
        end
        format.json { render :show, status: :created, location: @booking }
      else
        @houses = House.all
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route POST /booking/new (booking_new)
  def create_front
    search = Search.new(period: search_params, dtnb: @settings['dtnb'])
    house = House.find_by(number: params[:booking][:hid])
    answer = search.is_house_available? house.id
    prices = search.get_prices [house]
    client_details =  "#{params[:booking][:name]} #{params[:booking][:surname]} " +
                      "#{params[:booking][:adult]}+#{params[:booking][:children]}, " +
                      "#{params[:booking][:phone]}, #{params[:booking][:email]}"
    comment = "#{params[:booking][:flight_no]}-#{params[:booking][:flight_time]} / #{params[:booking][:comment]}"
    @booking = house.bookings.new(start: params[:booking][:start],
                                  finish: params[:booking][:finish],
                                  # house_id: house.id,
                                  client_details:,
                                  comment:,
                                  status: 'pending')
    @booking.calc prices
    @booking.number = "#{(('A'..'Z').to_a + ('0'..'9').to_a).sample(7).join}"
    @booking.ical_UID = "#{SecureRandom.hex(16)}@phuketmanage.com"
    @booking.save
    BookingMailer.created(@booking).deliver_later
    BookingMailer.send_request_confirmation(@booking, params[:booking][:email], I18n.locale).deliver_later
  end

  # @route GET /bookings/sync (sync_bookings)
  def sync
    if params[:hid].present?
      house = House.find_by(number: params[:hid])
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
    search = Search.new(period: search_params, dtnb: 0)
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
                                rf: @booking.finish })
          prices = search.get_prices [@booking.house]
          @booking.calc prices
          @booking.save
        end
        @booking.toggle_status
        hid = House.find(@booking.house_id).number
        format.html do
          redirect_to admin_house_bookings_path(@booking.house_id), notice: 'Booking was successfully updated.'
        end
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

  # @route PATCH /bookings/update_comment_gr (update_comment_gr_bookings)
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

  # @route GET /bookings/get_price (get_price_bookings)
  def get_price
    booking = Booking.new
    search = Search.new(period: "#{params[:start]} - #{params[:finish]}",
                        dtnb: 0)
    booking.house = House.find(params[:house_id])
    prices = search.get_prices [booking.house]
    booking.calc prices

    render json: { sale: booking.sale, comm: booking.comm, nett: booking.nett }
  end

  private

  def set_houses
    if current_user.role?('Owner')
      current_user.houses.for_rent.order(:code)
    else
      House.for_rent.order(:code)
    end
  end

  def set_period(params)
    from = params[:from]
    to = params[:to]
    error = false
    if !from.present? && !to.present?
      from = Date.current
      if current_user.role?('Owner')
        house_ids = current_user.houses.ids
        bookings = Booking.for_owner.where(finish: @from.., house_id: house_ids, allotment: false)
      else
        bookings = Booking.active.where(finish: @from..)
      end
      to = bookings.maximum(:finish).to_date if bookings.any?
      to = from if !to.present? || to < from
    elsif !from.present? || !to.present?
      error = 'Both dates should be selected'
    end
    [from, to, error]
  end

  def search_params
    "#{params[:booking][:start]} to #{params[:booking][:finish]}"
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

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
                                    :ignore_warnings,
                                    :manual_price)
  end
end
