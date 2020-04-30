class DocumentsController < ApplicationController

  def statement
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
