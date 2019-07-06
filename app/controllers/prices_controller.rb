class PricesController < ApplicationController
  load_and_authorize_resource :house
  # load_and_authorize_resource :price, through: :house, shallow: true
  layout "admin"
  before_action :set_price, only: [:show, :edit, :update, :destroy]

  # GET /prices
  # GET /prices.json
  def index
    @house = House.find(params[:house_id])
    @prices = @house.prices.all
    @durations = @house.durations
    @duration = Duration.new
    @seasons = @house.seasons
    @season = Season.new
  end

  # GET /prices/1
  # GET /prices/1.json
  def show
  end

  # GET /prices/new
  def new
    @house = House.find(params[:house_id])
    @price = Price.new
    @durations = @house.durations
    @seasons = @house.seasons
  end

  # GET /prices/1/edit
  def edit
    @house = @price.house
    @durations = @house.durations
    @seasons = @house.seasons
  end

  # POST /prices
  # POST /prices.json
  def create
    @house = House.find(params[:house_id])
    @price = @house.prices.build(price_params)

    respond_to do |format|
      if @price.save
        format.html { redirect_to house_prices_path(@house), notice: 'Price was successfully created.' }
        format.json { render :index, status: :created, location: @price }
      else
        format.html { render :new }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_duration
    @house = House.find(params[:id])
    @seasons = @house.seasons
    @duration = @house.durations.build(duration_params)
    respond_to do |format|
      if @duration.save
        @seasons.each do |s|
          @price = @house.prices.create(duration_id: @duration.id,
                                        season_id: s.id,
                                        amount: 0)
        end
        format.html { redirect_to house_prices_path(@house), notice: 'Duration was successfully created.' }
        format.json { render :index, status: :created, location: @price }
      else
        @prices = @house.prices.all
        @durations = @house.durations.reload
        @season = Season.new
        format.html { render :index }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_season
    @house = House.find(params[:id])
    @durations = @house.durations
    @season = @house.seasons.build(season_params)
    respond_to do |format|
      if @season.save
        @durations.each do |d|
          @price = @house.prices.create(duration_id: d.id,
                                        season_id: @season.id,
                                        amount: 0)
        end
        format.html { redirect_to house_prices_path(@house), notice: 'Season was successfully created.' }
        format.json { render :index, status: :created, location: @price }
      else
        @prices = @house.prices.all
        @seasons = @house.seasons.reload
        @duration = Duration.new
        format.html { render :index }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prices/1
  # PATCH/PUT /prices/1.json
  def update
    @house = @price.house
    respond_to do |format|
      if @price.update(price_params)
        format.html { redirect_to house_prices_path(@house), notice: 'Price was successfully updated.' }
        format.json { render :show, status: :ok, location: @price }
      else
        format.html { render :edit }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
    # def update_fb_post_id
    #   # byebug
    #   post = Post.find(params[:id])
    #   post.update("fb_post_id_#{params[:locale]}": params[:fb_post_id])
    #   render json: { status: :ok }
    # end

  end

  def update_ajax
    # @house = @price.house
    # respond_to do |format|
      price = Price.find(params[:id])
      puts params
      if price.update(price_params)
        render json: { price_id: price.id, status: :ok }
      else
        render json: {errors: price.errors, price_id: price.id}, status: :unprocessable_entity
      end
    # end
  end

  # DELETE /prices/1
  # DELETE /prices/1.json
  def destroy
    house = @price.house
    @price.destroy
    respond_to do |format|
      format.html { redirect_to house_prices_url(house), notice: 'Price was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_duration
    house = House.find(params[:id])
    duration = Duration.find(params[:duration_id])
    Price.where(duration_id: duration.id).destroy_all
    duration.destroy
    respond_to do |format|
      format.html { redirect_to house_prices_url(house), notice: 'Duration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_season
    house = House.find(params[:id])
    season = Season.find(params[:season_id])
    Price.where(season_id: season.id).destroy_all
    season.destroy
    respond_to do |format|
      format.html { redirect_to house_prices_url(house), notice: 'Duration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
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
