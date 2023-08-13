class Admin::PricesController < ApplicationController
  include SeasonsHelper
  include Loggable
  load_and_authorize_resource :house, id_param: :number
  # load_and_authorize_resource :price, through: :house, shallow: true
  layout "admin"
  before_action :set_house, only: %i[index new
                                     create_duration create_season
                                     destroy_duration destroy_season
                                     copy_table]
  before_action :set_price, only: %i[show edit update destroy]

  # @route GET /admin_houses/:admin_house_id/prices (admin_house_prices)
  def index
    @houses = House.all.for_rent
    # @house = House.find(params[:house_id])
    @prices = @house.prices.all
    @durations = @house.durations.order(:start)
    @duration = Duration.new
    @seasons = @house.seasons.order(:created_at)
    @season = Season.new
  end

  def show; end

  def new
    # @house = House.find(params[:house_id])
    @price = Price.new
    @durations = @house.durations
    @seasons = @house.seasons
  end

  def edit
    @house = @price.house
    @durations = @house.durations
    @seasons = @house.seasons
  end

  # def create
  #   @house = House.find(params[:house_id])
  #   @price = @house.prices.build(price_params)

  #   respond_to do |format|
  #     if @price.save
  #       format.html { redirect_to house_prices_path(@house), notice: 'Price was successfully created.' }
  #       format.json { render :index, status: :created, location: @price }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @price.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # @route POST /admin_houses/:admin_house_id/add_duration (admin_house_add_duration)
  def create_duration
    # @house = House.find(params[:id])
    @seasons = @house.seasons
    @duration = @house.durations.build(duration_params)
    respond_to do |format|
      if @duration.save
        @seasons.each do |s|
          @price = @house.prices.create!(duration_id: @duration.id,
                                         season_id: s.id,
                                         amount: 0)
        end
        format.html { redirect_to admin_house_prices_path(@house.number), notice: 'Duration was successfully created.' }
        format.json { render :index, status: :created, location: @price }
      else
        @houses = House.all.active
        @prices = @house.prices.all
        @durations = @house.durations.reload
        @season = Season.new
        format.html { render :index }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route POST /admin_houses/:admin_house_id/add_season (admin_house_add_season)
  def create_season
    # @house = House.find(params[:id])
    @durations = @house.durations
    @season = @house.seasons.build(season_params)
    respond_to do |format|
      if @season.save
        @durations.each do |d|
          @house.prices.create!(duration_id: d.id,
                                season_id: @season.id,
                                amount: 0)
        end
        format.html { redirect_to house_prices_path(@house.number), notice: 'Season was successfully created.' }
        format.json { render :index, status: :created, location: @price }
      else
        @houses = House.all.active
        @prices = @house.prices.all
        @seasons = @house.seasons.reload
        @duration = Duration.new
        format.html { render :index }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route POST /prices/:house_id/copy_table (copy_table)
  def copy_table
    # @house = House.find(params[:id])
    copy_from_number = params[:copy_from_number]
    durations_from = House.find_by(number: copy_from_number).durations
    if durations_from.any?
      durations_from.each do |d|
        @house.durations.create!(start: d.start, finish: d.finish)
        # puts "Add duration: start: #{d.start}, finish: #{d.finish}"
      end
    end
    # byebug
    seasons_from = House.find_by(number: copy_from_number).seasons
    if seasons_from.any?
      seasons_from.each do |s|
        @house.seasons.create!(ssd: s.ssd, ssm: s.ssm, sfd: s.sfd, sfm: s.sfm)
        # puts "Add season: ssd: #{s.ssd}, ssm: #{s.ssm}, sfd: #{s.sfd}, sfm: #{s.sfm}"
      end
    end
    durations_to = @house.durations
    seasons_to = @house.seasons
    durations_to.each do |d|
      seasons_to.each do |s|
        @house.prices.create!(duration_id: d.id,
                              season_id: s.id,
                              amount: 0)
      end
    end
    redirect_to admin_house_prices_path(@house.id)
  end

  # @route GET /prices/:id/update (price)
  def update
    price = Price.find(params[:id])
    if price.update(price_params)
      log_event(price)
      render json: { price_id: price.id, status: :ok }
    else
      render json: { errors: price.errors, price_id: price.id }, status: :unprocessable_entity
    end
  end

  def destroy
    house = @price.house
    @price.destroy
    respond_to do |format|
      format.html { redirect_to admin_house_prices_url(house.id), notice: 'Price was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # @route DELETE /admin_houses/:admin_house_id/delete_duration (admin_house_delete_duration)
  def destroy_duration
    # house = House.find(params[:id])
    duration = Duration.find(params[:duration_id])
    Price.where(duration_id: duration.id).destroy_all
    duration.destroy
    respond_to do |format|
      format.html { redirect_to admin_house_prices_url(@house.id), notice: 'Duration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # @route DELETE /admin_houses/:admin_house_id/delete_season (admin_house_delete_season)
  def destroy_season
    # house = House.find(params[:id])
    season = Season.find(params[:season_id])
    Price.where(season_id: season.id).destroy_all
    season.destroy
    respond_to do |format|
      format.html { redirect_to admin_house_prices_url(@house.id), notice: 'Duration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_house
    @house = House.find_by(id: params[:admin_house_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_price
    @price = Price.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def price_params
    params.require(:price).permit(:house_id, :season_id, :duration_id, :amount)
  end

  def duration_params
    params.require(:duration).permit(:start, :finish, :house_id)
  end

  def season_params
    params.require(:season).permit(:ssd, :ssm, :sfd, :sfm, :house_id)
  end
end
