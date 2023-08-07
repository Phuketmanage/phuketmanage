class BookingFilesController < ApplicationController
  load_and_authorize_resource

  before_action :set_booking_file, only: %i[update destroy]

  # @route POST /booking_files (booking_files)
  def create
    booking_number = params[:booking_number]
    booking = Booking.find_by(number: booking_number)
    file = File.new(params[:booking_file][:file])
    content_type = params[:booking_file][:file].content_type
    extention = File.extname(file)
    new_name = "#{Time.current.to_i}#{extention}"
    obj = S3_BUCKET.object("bookings/#{booking.number}/#{new_name}")
    obj.upload_file(file, acl: 'public-read', content_type: content_type)
    @file = booking.files.new(booking_file_params)
    @file.url = obj.key
    @file.user_id = current_user.id
    if @file.save
    else
      redirect_to jobs_path
    end
  end

  # @route PATCH /booking_files/:id (booking_file)
  # @route PUT /booking_files/:id (booking_file)
  def update; end

  # @route DELETE /booking_files/:id (booking_file)
  def destroy
    @file.destroy
  end

  private

  def set_booking_file
    @file = BookingFile.find(params[:id])
  end

  def booking_file_params
    params.require(:booking_file).permit(:name, :comment, :user_id)
  end
end
