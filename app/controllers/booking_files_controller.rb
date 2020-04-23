class BookingFilesController < ApplicationController
  load_and_authorize_resource

  before_action :set_file, only: [ :update, :destroy ]

  def create
    booking_number = params[:booking_number]
    file_name = params[:file_name]
    file = File.new(params[:file])
    content_type = params[:file].content_type
    extention = File.extname(file)
    obj = S3_BUCKET.object("bookings/#{booking_number}/#{file_name}#{extention}")
    obj.upload_file(file, acl: 'public-read', content_type: content_type)

  end

  def update
  end

  def destroy
  end
  private
    def set_booking_file
      @file = BookingFile.find(params[:id])
    end

end
