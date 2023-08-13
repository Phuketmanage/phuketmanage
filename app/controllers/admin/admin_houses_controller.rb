# rubocop:disable RSpec/Metrics/ClassLength

class Admin::AdminHousesController < ApplicationController
  load_and_authorize_resource :house, id_param: :number

  before_action :set_house, only: %i[show edit update destroy]
  before_action :search, only: :show
  layout 'admin', except: :show

  # @route GET (/:locale)/houses {locale: nil} (houses)
  def index
    @houses_for_rent = House.for_rent
    @houses_not_for_rent = House.not_for_rent
  end

  # @route GET (/:locale)/houses/export {locale: nil} (export_houses)
  def export
    @houses_for_rent = House.for_rent
    @houses_not_for_rent = House.not_for_rent
    render layout: 'application', locals: { print: true }
  end

  # @route GET (/:locale)/houses/inactive {locale: nil} (houses_inactive)
  def inactive
    @inactive_houses = House.inactive
  end

  # @route GET (/:locale)/test_upload {locale: nil} (test_upload)
  def test_upload
    @house = House.new
  end

  # @route GET (/:locale)/houses/:id {locale: nil} (house)
  def show
    @occupied_days = @house.occupied_days(@settings['dtnb'])
    @min_date = @search.min_date
  end

  # @route GET (/:locale)/houses/new {locale: nil} (new_house)
  def new
    @house = House.new
    @owners = User.with_role('Owner')
    @types = HouseType.all
    @sources = Source.syncable.order(:name)
    @connections = @house.connections.all
    @connection = @house.connections.new
    @job_types = JobType.all
  end

  # @route GET (/:locale)/houses/:id/edit {locale: nil} (edit_house)
  def edit
    @owners = User.with_role('Owner')
    @types = HouseType.all
    @sources = Source.syncable.order(:name)
    @connections = @house.connections.all
    @connection = @house.connections.new
  end

  # @route POST (/:locale)/houses {locale: nil} (houses)
  def create
    options = params[:options] || nil
    @house = House.new(house_params)
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

  # @route PATCH (/:locale)/houses/:id {locale: nil} (house)
  # @route PUT (/:locale)/houses/:id {locale: nil} (house)
  def update
    respond_to do |format|
      if @house.update(house_params)
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

  # @route DELETE (/:locale)/houses/:id {locale: nil} (house)
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

  def house_params
    params.require(:house).permit(
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
