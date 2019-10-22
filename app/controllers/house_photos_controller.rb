class HousePhotosController < ApplicationController
  load_and_authorize_resource id_param: :number

  before_action :get_house, only: [:index, :add]
  before_action :get_photo, only: [:update]
  layout 'admin'

  def index
    @photos = @house.photos.order(:url)
    @s3_direct_post = S3_BUCKET.presigned_post(key: "house_photos/#{@house.number}/${filename}", success_action_status: '201', acl: 'public-read')
  end

  def add
    url = params[:photo_url]
    preview = params[:preview]
    if preview
      S3_BUCKET.object(@house.image).delete if @house.image
      @house.update(image: url)
      render json: {status: :ok} and return
    else
      if HousePhoto.find_by(url: url)
        render json: {status: 'Photo url already exist in DB'}
      end
      photo = @house.photos.create!(url: url, title_en: '', title_ru: '')
      file_name = photo.url.match(/^.*[\/](.*)$/)
      render json: {status: :ok, id: photo.id, file_name: file_name[1]} and return
    end

  end

  def update
    @photo.update(house_photo_params)
    render json: {status: :ok}
    # respond_to do |format|
    #   format.js
    # end
  end

  def delete

    if params[:hid]
      house = House.find_by(number: params[:hid])
      S3_BUCKET.objects({prefix:"house_photos/#{house.number}"}).batch_delete!
      house.photos.destroy_all
      house.update(image: nil)
      redirect_to house_photos_path(house.number)
    else
      @photo = HousePhoto.find(params[:id])
      S3_BUCKET.object(@photo.key).delete
      S3_BUCKET.object(@photo.thumb_key).delete
      @photo.destroy
      respond_to do |format|
        format.js
      end
    end

  end


  private

    def get_house
      @house = House.find_by(number: params[:house_id])
    end

    def get_photo
      @photo = HousePhoto.find(params[:id])
    end

    def house_photo_params
      params.require(:house_photo).permit(:title_en, :title_ru)
    end

end
