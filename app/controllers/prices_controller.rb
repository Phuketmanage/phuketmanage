class PricesController < ApplicationController
  load_and_authorize_resource

  before_action :set_price, only: [:show, :edit, :update, :destroy]

  # GET /prices
  # GET /prices.json
  def index
    @house = House.find(params[:house_id])
    @prices = @house.prices.order(:duration_id)
    @durations = @house.durations
    @seasons = @house.seasons
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
        format.json { render :show, status: :created, location: @price }
      else
        format.html { render :new }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price
      @price = Price.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_params
      params.require(:price).permit(:house_id, :season_id, :duration_id, :amount)
    end
end
