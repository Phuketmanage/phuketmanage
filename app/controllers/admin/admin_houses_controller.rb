# rubocop:disable RSpec/Metrics/ClassLength

class Admin::AdminHousesController < AdminController
  load_and_authorize_resource class: House, id_param: :number

  before_action :set_house, only: %i[show edit update destroy]
  before_action :search, only: :show

  # @route GET /admin_houses (admin_houses)
  def index
    @houses_for_rent = House.for_rent
    @houses_not_for_rent = House.not_for_rent
  end

  # @route GET /admin_houses/export (export_admin_houses)
  def export
    @houses_for_rent = House.for_rent
    @houses_not_for_rent = House.not_for_rent
    render layout: 'application', locals: { print: true }
  end

  # @route GET /admin_houses/inactive (inactive_admin_houses)
  def inactive
    @inactive_houses = House.inactive
  end

  def test_upload
    @house = House.new
  end

  # @route GET /admin_houses/:id (admin_house)
  def show
    @occupied_days = @house.occupied_days(@settings['dtnb'])
    @min_date = @search.min_date
  end

  # @route GET /admin_houses/new (new_admin_house)
  def new
    @house = House.new
    @owners = User.with_role('Owner')
    @types = HouseType.all
    @sources = Source.syncable.order(:name)
    @connections = @house.connections.all
    @connection = @house.connections.new
    @job_types = JobType.all
  end

  # @route GET /admin_houses/:id/edit (edit_admin_house)
  def edit
    @owners = User.with_role('Owner')
    @types = HouseType.all
    @sources = Source.syncable.order(:name)
    @connections = @house.connections.all
    @connection = @house.connections.new
  end

  # @route POST /admin_houses (admin_houses)
  def create
    options = params[:options] || nil
    @house = House.new(admin_house_params)
    @house.secret = SecureRandom.hex(16)
    respond_to do |format|
      if @house.save
        format.html { redirect_to admin_houses_path, notice: "House #{@house.code} was successfully created." }
        format.json { render :show, status: :created, location: @house }
      else
        @owners = User.with_role('Owner')
        @types = HouseType.all
        @sources = Source.syncable.order(:name)
        @connections = @house.connections.all
        @connection = @house.connections.new
        format.html { render :new }
        format.json { render json: @house.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /admin_houses/:id (admin_house)
  # @route PUT /admin_houses/:id (admin_house)
  def update
    respond_to do |format|
      if @house.update(admin_house_params)
        format.html { redirect_to admin_houses_path, notice: "House #{@house.code} was successfully updated." }
        format.json { render :show, status: :ok, location: @house }
      else
        @owners = User.with_role('Owner')
        @types = HouseType.all
        @connections = @house.connections.all
        @connection = @house.connections.new
        format.html { render :edit }
        format.json { render json: @house.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /admin_houses/:id (admin_house)
  def destroy
    @house.destroy
    respond_to do |format|
      format.html { redirect_to admin_houses_url, notice: 'House was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_house
    @house = House.find_by!(number: params[:id])
  end

  def search
    if params[:period].blank?
      @search = Search.new
    else
      preform_search
    end
  end

  def preform_search
    @search = Search.new(period: params[:period], dtnb: @settings['dtnb'])

    return unless @search.valid?

    answer = @search.is_house_available? @house.id
    if answer[:result]
      @houses = [@house]
      @prices = @search.get_prices @houses
      @booking = Booking.new
    else
      @prices = "unavailable"
    end
  end

  def admin_house_params
    params.require(:admin_house).permit(
      :code,
      :description_en,
      :description_ru,
      :owner_id,
      :type_id,
      :size,
      :plot_size,
      :rooms,
      :bathrooms,
      :pool,
      :pool_size,
      :communal_pool,
      :parking,
      :parking_size,
      :unavailable,
      :rental,
      :maintenance,
      :outsource_cleaning,
      :outsource_linen,
      :address,
      :google_map,
      { employee_ids: [] },
      :image,
      :capacity,
      :seaview,
      :kingBed,
      :queenBed,
      :singleBed,
      :priceInclude_en,
      :priceInclude_ru,
      :cancellationPolicy_en,
      :cancellationPolicy_ru,
      { option_ids: [] },
      { location_ids: [] },
      :project,
      :rules_en,
      :rules_ru,
      :other_en,
      :other_ru,
      :details,
      :house_group_id,
      :water_meters,
      :water_reading,
      :balance_closed,
      :hide_in_timeline,
      :photo_link
    )
  end
end
