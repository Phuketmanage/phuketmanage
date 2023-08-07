class TransfersController < ApplicationController
  load_and_authorize_resource

  layout 'admin', except: %i[index_supplier confirmed canceled]
  before_action :set_transfer, only: %i[show update destroy cancel]

  # @route GET (/:locale)/transfers {locale: nil} (transfers)
  def index
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

  # @route GET (/:locale)/transfers/supplier {locale: nil} (transfers_supplier)
  def index_supplier
    today = Date.current
    @transfers = Transfer.where('date >= ?', today).order(:date)
  end

  # @route GET (/:locale)/transfers/:id {locale: nil} (transfer)
  def show
    render json: @transfer
  end

  # @route GET (/:locale)/transfers/new {locale: nil} (new_transfer)
  def new
    @transfer = Transfer.new
    respond_to do |format|
      format.js
    end
  end

  # @route GET (/:locale)/transfers/:id/edit {locale: nil} (edit_transfer)
  def edit
    @transfer = Transfer.find(params[:id])
    @select_items = House.for_rent.order(:code).map { |h| [h.code, h.number] }
    @select_items.push('Airport (International)', 'Airport (Domiestic)')
    @request_from = params[:request_from]
    respond_to do |format|
      format.js
    end
  end

  # @route POST (/:locale)/transfers {locale: nil} (transfers)
  def create
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
        TransfersMailer.created(@transfer).deliver_now
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

  # @route GET (/:locale)/transfers/:number/confirmed {locale: nil} (supplier_confirm_transfer)
  def confirmed
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

  # @route PATCH (/:locale)/transfers/:id {locale: nil} (transfer)
  # @route PUT (/:locale)/transfers/:id {locale: nil} (transfer)
  def update
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
          TransfersMailer.amended(@transfer, changes).deliver_now
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

  # @route GET (/:locale)/transfers/:id/cancel {locale: nil} (cancel_transfer)
  def cancel
    respond_to do |format|
      if @transfer.update(status: 'canceling')
        if params[:request_from] == 'bookings'
          @transfers = @transfer.booking.transfers
        else
          today = Date.current
          @transfers = Transfer.where('date >= ?', today).order(:date)
        end
        TransfersMailer.canceled(@transfer).deliver_now
        format.js
      else
        render "Was not able to change transfer and send ammendment request."
      end
    end
  end

  # @route GET (/:locale)/transfers/:number/canceled {locale: nil} (supplier_cancel_transfer)
  def canceled
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

  # @route DELETE (/:locale)/transfers/:id {locale: nil} (transfer)
  def destroy
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
