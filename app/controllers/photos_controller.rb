class PhotosController < ApplicationController
  before_action :get_house
  layout 'admin'

  def index
    @s3_direct_post = S3_BUCKET.presigned_post(key: "house_photos/#{@house.number}/${filename}", success_action_status: '201', acl: 'public-read')

  end

  def add
    url = params[:photo_url]
    @house.photos.create!(url: url, title_en: '', title_ru: '')
    render json: {status: :ok}

  end

  def delete
    House::Photo.find(params[:photo_id]).destroy
    render json: {status: :ok}

  end


  private

    def get_house
      @house = House.find_by(number: params[:house_id])
    end

end
