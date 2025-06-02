class Admin::TransfersController < Admin::AdminController
  before_action :set_transfer, only: %i[show update destroy cancel]

  # @route GET /transfers (transfers)
  def index
    authorize!
    if !params[:from].present? && !params[:to].present?
      today = Date.current
      @transfers = Transfer.where('date >= ?', today).order(:date).all
    elsif params[:from].present? && !params[:to].present?
      from = params[:from].to_date
      today = Date.current
      @transfers = Transfer.where('date >= ? AND date <= ?', from, today).order(:date).all
    elsif params[:from].present? && params[:to].present?
      from = params[:from].to_date
      to = params[:to].to_date
      @transfers = Transfer.where('date >= ? AND date <= ?', from, to).order(:date).all
    end
    @transfer = Transfer.new
    @select_items = House.for_rent.order(:code).map { |h| [h.code, h.number] }
    @select_items.push('Airport (International)', 'Airport (Domiestic)')
  end

  # @route GET /transfers/supplier (transfers_supplier)
  def index_supplier
    authorize!
    today = Date.current
    @transfers = Transfer.where('date >= ?', today).order(:date)
  end

  # @route GET /transfers/:id (transfer)
  def show
    authorize!
    render json: @transfer
  end

  # @route GET /transfers/new (new_transfer)
  def new
    authorize!
    @transfer = Transfer.new
    respond_to do |format|
      format.js
    end
  end

  # @route GET /transfers/:id/edit (edit_transfer)
  def edit
    authorize!
    @transfer = Transfer.find(params[:id])
    @select_items = House.for_rent.order(:code).map { |h| [h.code, h.number] }
    @select_items.push('Airport (International)', 'Airport (Domiestic)')
    @request_from = params[:request_from]
    respond_to do |format|
      format.js
    end
  end

  # @route POST /transfers (transfers)
  def create
    authorize!
    @transfer = Transfer.new(transfer_params)
    trsf_booking_no = "#{(('A'..'Z').to_a + ('0'..'9').to_a).sample(7).join}"
    @transfer.number = trsf_booking_no
    @transfer.status = "sent"
    respond_to do |format|
      if @transfer.save
        if @transfer.booking_id.nil?
          today = Date.current
          @transfers = Transfer.where('date >= ?', today).order(:date)
        else
          @transfers = @transfer.booking.transfers
        end
        format.js
        format.json { render json: { transfer: @transfer }, status: :created }
        TransfersMailer.created(@transfer).deliver_later
      else
        @transfers = Transfer.all
        @transfer = Transfer.new
        @select_items = House.active.order(:code).map { |h| [h.code, h.number] }
        @select_items.push('Airport (International)', 'Airport (Domiestic)')

        format.html { render :index }
        format.json { render json: @transfer.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route GET /transfers/:number/confirmed (supplier_confirm_transfer)
  def confirmed
    authorize!
    @transfer = Transfer.find_by(number: params[:number])
    if @transfer.nil?
      @notice = "There is no such transfer with booking no #{params[:number]}"
      @color = "text-danger"
      nil
    elsif @transfer.update(status: "confirmed")
      @notice = 'Transfer was successfully confirmed.'
      @color = "text-success"
      nil
    else
      @notice = 'Something went wrong. Transfer was not confirmed.'
      @color = "text-danger"
    end
  end

  # @route PATCH /transfers/:id (transfer)
  # @route PUT /transfers/:id (transfer)
  def update
    authorize!
    # transfer = Transfer.find_by(number: params[:id])
    @transfer.attributes = transfer_params
    changes = @transfer.changes
    # if params[:transfer].key?(:new_from)
    #   @transfer.from = params[:transfer][:from_text]
    # else
    #   @transfer.from = params[:transfer][:from_select]
    # end
    # if params[:transfer].key?(:new_to)
    #   @transfer.from = params[:transfer][:to_text]
    # else
    #   @transfer.from = params[:transfer][:to_select]
    # end

    if params[:request_from] == 'bookings'
      @transfers = @transfer.booking.transfers.order(:date)
    else
      today = Date.current
      @transfers = Transfer.where('date >= ?', today).order(:date)
    end
    respond_to do |format|
      if @transfer.update(transfer_params)
        if changes.any?
          @transfer.update(status: "amended")
          TransfersMailer.amended(@transfer, changes).deliver_later
        end
        # redirect_to admin_transfers_path, notice: 'Ammendment request was successfully sent.'
        format.js
      else
        render "Was not able to sent ammendment request."
      end
    end

    # respond_to do |format|
    #    if @transfer.update(transfer_params)
    #      format.html { redirect_to admin_transfers_path, notice: 'Ammendment request was successfully sent.' }
    #      format.json { render :show, status: :ok, location: @transfer }
    #      if changes.any?

    #      end
    #    else
    #      format.html { render "Was not able to sent ammendment request." }
    #      format.json { render json: @transfer.errors, status: :unprocessable_entity }
    #    end
    # end
  end

  # @route GET /transfers/:id/cancel (cancel_transfer)
  def cancel
    authorize!
    respond_to do |format|
      if @transfer.update(status: 'canceling')
        if params[:request_from] == 'bookings'
          @transfers = @transfer.booking.transfers
        else
          today = Date.current
          @transfers = Transfer.where('date >= ?', today).order(:date)
        end
        TransfersMailer.canceled(@transfer).deliver_later
        format.js
      else
        render "Was not able to change transfer and send ammendment request."
      end
    end
  end

  # @route GET /transfers/:number/canceled (supplier_cancel_transfer)
  def canceled
    authorize!
    @transfer = Transfer.find_by(number: params[:number])
    if @transfer.nil?
      @notice = "There is no such transfer with booking no #{params[:number]}"
      @color = "text-danger"
      nil
    elsif @transfer.update(status: "canceled")
      @notice = 'Transfer was successfully canceled.'
      @color = "text-success"
      nil
    else
      @notice = 'Something went wrong. Transfer was not canceled.'
      @color = "text-danger"
    end
  end

  # @route DELETE /transfers/:id (transfer)
  def destroy
    authorize!
    @transfer.destroy
    respond_to do |format|
      if params[:request_from] == 'bookings'
        @transfers = @transfer.booking.transfers
      else
        today = Date.current
        @transfers = Transfer.where('date >= ?', today).order(:date)
      end
      format.js
      # format.html { redirect_to transfers_url, notice: 'Transfer was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_transfer
    @transfer = Transfer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transfer_params
    params.require(:transfer).permit(:booking_id, :date, :trsf_type, :from, :time, :client, :pax, :to, :remarks,
                                     :booked_by, :number)
  end
end
