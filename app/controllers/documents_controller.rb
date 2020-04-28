class DocumentsController < ApplicationController

  def statement
    if params[:booking_id].present?
      @booking = Booking.find(params[:booking_id])
      @owner = @booking.house.owner
      @usd = 29
    end
  end

  def reimbersment
    if params[:booking_id].present?
      @booking = Booking.find(params[:booking_id])
      @owner = @booking.house.owner
      @usd = 29
    end

  end

  def invoice

  end

  def receipt

  end



end
