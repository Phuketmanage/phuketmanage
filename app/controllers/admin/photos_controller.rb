class Admin::PhotosController < AdminController
  before_action :get_house
  before_action :get_photo, only: %i[update sort destroy]


  # @route GET /admin_houses/:admin_house_id/photos (admin_house_photos)
  def index
    authorize! with: Admin::PhotoPolicy
    @photos = @house.photos.rank(:position)
    @s3_direct_post = S3_BUCKET.presigned_post(key: "house_photos/#{@house.number}/${filename}",
                                               success_action_status: '201', acl: 'public-read')
  end

  # @route PUT /admin_houses/:admin_house_id/photos/:id/sort (sort_admin_house_photo)
  def sort
    authorize! with: Admin::PhotoPolicy
    @photo.update(position_position: params[:position])
    head :ok
  end

  # @route GET /admin_houses/:admin_house_id/photos/new (new_admin_house_photo)
  def new
    authorize! with: Admin::PhotoPolicy
    url = params[:photo_url]
    preview = params[:preview]
    render json: { status: 'duplicate' } and return if HousePhoto.find_by(url:)

    photo = @house.photos.create!(url:, title_en: '', title_ru: '')
    # If preview is empty set it to first uploaded image
    @house.update(image: url) unless @house.image.present?
    file_name = photo.url.match(%r{^.*/(.*)$})
    render json: { status: :ok, id: photo.id, file_name: file_name[1] } and return
  end

  # @route PATCH /admin_houses/:admin_house_id/photos/:id (admin_house_photo)
  # @route PUT /admin_houses/:admin_house_id/photos/:id (admin_house_photo)
  def update
    authorize! with: Admin::PhotoPolicy
    @photo.update(house_photo_params)
    if params[:commit] == "Use as default"
      @photo.house.update(image: @photo.url)
      redirect_to admin_house_photos_path(@house.number) and return
    end
    render json: { status: :ok }
  end

  # @route DELETE /admin_houses/:admin_house_id/photos/:id (admin_house_photo)
  def destroy
    authorize! with: Admin::PhotoPolicy
    S3_BUCKET.object(@photo.key).delete
    S3_BUCKET.object(@photo.thumb_key).delete
    @photo.destroy
    respond_to do |format|
      format.js
    end
  end

  # @route DELETE /admin_houses/:admin_house_id/photos/delete_all (delete_all_admin_house_photos)
  def delete_all
    authorize! with: Admin::PhotoPolicy
    S3_BUCKET.objects({ prefix: "house_photos/#{@house.number}" }).batch_delete!
    @house.photos.destroy_all
    @house.update(image: nil)
    redirect_to admin_house_photos_path(@house.number)
  end

  private

  def get_house
    @house = House.find_by(number: params[:admin_house_id])
  end

  def get_photo
    @photo = HousePhoto.find(params[:id])
  end

  def house_photo_params
    params.require(:house_photo).permit(:title_en, :title_ru)
  end
end
