class HousePhotosController < ApplicationController
  before_action :get_house
  layout 'admin'

  def index
    @photos = @house.photos
    @s3_direct_post = S3_BUCKET.presigned_post(key: "house_photos/#{@house.number}/${filename}", success_action_status: '201', acl: 'public-read')

  end

  def add
    url = params[:photo_url]
    if HousePhoto.find_by(url: url)
      render json: {status: 'Photo url already exist in DB'}
    end
    photo = @house.photos.create!(url: url, title_en: '', title_ru: '')
    file_name = photo.url.match(/^.*[\/](.*)$/)
    render json: {status: :ok, id: photo.id, file_name: file_name[1]}


  end

  def delete
    @photo = HousePhoto.find(params[:id])
    S3_BUCKET.object(@photo.key).delete
    S3_BUCKET.object(@photo.thumb_key).delete
    @photo.destroy
    respond_to do |format|
      format.js
    end

  end


  private

    def get_house
      @house = House.find_by(number: params[:house_id])
    end

end
