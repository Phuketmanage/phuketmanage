class DocumentsController < ApplicationController

  def statement

    @usd = 29
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

  def reimbersment
    @t = Transaction.find(params[:trsc_id])
    @usd = 29
    if @t.type.name_en == 'Rental'
      @to = { name: Booking.find(@t.booking_id).client_details,
              address: '' }
    else
      @to = { name: "#{@t.user.name} #{@t.user.surname}",
              address: '' }
    end
  end

  def invoice

  end

  def receipt

  end



end
