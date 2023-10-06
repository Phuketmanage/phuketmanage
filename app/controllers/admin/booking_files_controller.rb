class Admin::BookingFilesController < AdminController
  before_action :set_booking, only: %i[create]
  before_action :set_booking_file, only: %i[destroy]

  # @route POST /bookings/:id/booking_files (booking_files)
  def create
    authorize!
    @booking_file = @booking.files.new(booking_file_params)
    @booking_file.user_id = current_user.id
    if @booking_file.save
      respond_to_success
    else
      render :new, status: :unprocessable_entity
    end
  end

  # @route DELETE /booking_files/:id (booking_file)
  def destroy
    authorize!
    @booking_file.destroy

    respond_to_success
  end

  private

  def respond_to_success
    respond_to do |format|
      format.html { redirect_back fallback_location: }
      format.turbo_stream do
        render status: :ok
      end
    end
  end

  def fallback_location
    bookings_path(@booking_file.booking)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_booking_file
    @booking_file = BookingFile.find(params[:id])
  end

  def booking_file_params
    params.require(:booking_file).permit(:name, :comment, :data)
  end
end
