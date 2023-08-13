class Admin::PhotosController < ApplicationController
  load_and_authorize_resource :house_photo, id_param: :number

  before_action :get_house, only: %i[index add]
  before_action :get_photo, only: [:update]
  layout 'admin'

  # @route GET (/:locale)/houses/:house_id/photos {locale: nil} (house_photos)
  def index
    @photos = @house.photos.rank(:position)
    @s3_direct_post = S3_BUCKET.presigned_post(key: "house_photos/#{@house.number}/${filename}",
                                               success_action_status: '201', acl: 'public-read')
  end

  # @route PUT (/:locale)/house_photos/:id/sort {locale: nil} (house_photos_sort)
  def sort
    @photo = HousePhoto.find(params[:id])
    @photo.update(position_position: params[:position])
    head :ok
  end

  # @route GET (/:locale)/houses/:house_id/photos/add {locale: nil} (house_photos_add)
  def new
    url = params[:photo_url]
    preview = params[:preview]
    render json: { status: 'duplicate' } and return if HousePhoto.find_by(url:)

    photo = @house.photos.create!(url:, title_en: '', title_ru: '')
    # If preview is empty set it to first uploaded image
    @house.update(image: url) unless @house.image.present?
    file_name = photo.url.match(%r{^.*/(.*)$})
    render json: { status: :ok, id: photo.id, file_name: file_name[1] } and return
  end

  # @route PATCH (/:locale)/house_photos/:id {locale: nil} (house_photo_update)
  def update
    @photo.update(house_photo_params)
    if params[:commit] == "Use as default"
      @photo.house.update(image: @photo.url)
      redirect_to admin_house_photos_path(@photo.house.id) and return
    end
    render json: { status: :ok }

    # respond_to do |format|
    #   format.js
    # end
  end

  # @route DELETE (/:locale)/house_photos/:id {locale: nil} (house_photo_delete)
  # @route DELETE (/:locale)/houses/:hid/delete_photos {locale: nil} (house_photo_delete_all)
  def delete
    if params[:hid]
      house = House.find_by(number: params[:hid])
      S3_BUCKET.objects({ prefix: "house_photos/#{house.number}" }).batch_delete!
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
    @house = House.find_by(number: params[:admin_house_id])
  end

  def get_photo
    @photo = HousePhoto.find(params[:id])
  end

  def house_photo_params
    params.require(:photo).permit(:title_en, :title_ru)
  end
end
