class Admin::DocumentsController < Admin::AdminController

  # @route GET /documents/statement (tmp_statement)
  def statement
    authorize! with: Admin::DocumentsPolicy
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
      @date = Time.current
      @owner = User.find(params[:owner_id])
      @to = { name: "#{@owner.name} #{@owner.surname}",
              address: '' }

    end
  end

  # @route GET /documents/reimbersment (tmp_reimbersment)
  def reimbersment
    authorize! with: Admin::DocumentsPolicy
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

  def invoice
    authorize! with: Admin::DocumentsPolicy
  end

  def receipt
    authorize! with: Admin::DocumentsPolicy
  end
end
