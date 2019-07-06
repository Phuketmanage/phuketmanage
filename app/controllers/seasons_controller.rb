class SeasonsController < ApplicationController
  load_and_authorize_resource :house
  # load_and_authorize_resource :price, through: :house, shallow: true

  before_action :set_season, only: [:show, :edit, :update, :destroy]

  # GET /seasons
  # GET /seasons.json
  def index
    @house = House.find(params[:house_id])
    @seasons = @house.seasons
  end

  # GET /seasons/1
  # GET /seasons/1.json
  def show
  end

  # GET /seasons/new
  def new
    @house = House.find(params[:house_id])
    @season = Season.new
  end

  # GET /seasons/1/edit
  def edit
    @house = @season.house
  end

  # POST /seasons
  # POST /seasons.json
  def create
    @house = House.find(params[:house_id])
    @season = @house.seasons.build(season_params)

    respond_to do |format|
      if @season.save
        format.html { redirect_to house_seasons_path(@house), notice: 'Season was successfully created.' }
        format.json { render :show, status: :created, location: @season }
      else
        @houses = House.all
        format.html { render :new }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seasons/1
  # PATCH/PUT /seasons/1.json
  def update
    @house = @season.house
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to house_seasons_path(@house), notice: 'Season was successfully updated.' }
        format.json { render :show, status: :ok, location: @season }
      else
        format.html { render :edit }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.json
  def destroy
    @house = @season.house
    @season.destroy
    respond_to do |format|
      format.html { redirect_to house_seasons_path(@house), notice: 'Season was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season
      @season = Season.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def season_params
      params.require(:season).permit(:ssd, :ssm, :sfd, :sfm, :house_id)
    end
end
