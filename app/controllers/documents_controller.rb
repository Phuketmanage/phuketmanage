class DocumentsController < ApplicationController
  authorize_resource :class => false
  # @route GET /documents/statement (tmp_statement)
  def statement
    @usd = @settings['usd_rate'].present? ? @settings['usd_rate'].to_f : 30

    if params[:trsc_id].present?
      @t = Transaction.find(params[:trsc_id])
      @date = @t.date
      if @t.type.name_en == 'Rental'
        @owner = @t.user
        @to = { name: Booking.find(@t.booking_id).client_details,
                address: '' }
      else
        @owner = @t.user
        @to = { name: "#{@t.user.name} #{@t.user.surname}",
                address: '' }
      end
    elsif params[:owner_id].present?
      @date = Time.zone.now.in_time_zone('Bangkok')
      @owner = User.find(params[:owner_id])
      @to = { name: "#{@owner.name} #{@owner.surname}",
              address: '' }

    end
  end

  # @route GET /documents/reimbersment (tmp_reimbersment)
  def reimbersment
    @t = Transaction.find(params[:trsc_id])
    @date = @t.date
    @usd = 29
    @to = if @t.type.name_en == 'Rental'
      { name: Booking.find(@t.booking_id).client_details,
        address: '' }
    else
      { name: "#{@t.user.name} #{@t.user.surname}",
        address: '' }
    end
  end

  def invoice; end

  def receipt; end
end
