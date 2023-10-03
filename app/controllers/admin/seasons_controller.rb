class Admin::SeasonsController < AdminController
  verify_authorized
  before_action :set_season, only: %i[show edit update destroy]

  # GET /seasons
  # GET /seasons.json
  def index
    authorize!
    @house = House.find(params[:house_id])
    @seasons = @house.seasons
  end

  # GET /seasons/1
  # GET /seasons/1.json
  def show
    authorize!
  end

  # GET /seasons/new
  def new
    authorize!
    @house = House.find(params[:house_id])
    @season = Season.new
  end

  # GET /seasons/1/edit
  def edit
    authorize!
    @house = @season.house
  end

  # POST /seasons
  # POST /seasons.json
  def create
    authorize!
    @house = House.find(params[:house_id])
    @season = @house.seasons.build(season_params)

    respond_to do |format|
      if @season.save
        format.html { redirect_to admin_house_seasons_path(@house), notice: 'Season was successfully created.' }
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
    authorize!
    @house = @season.house
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to admin_house_seasons_path(@house), notice: 'Season was successfully updated.' }
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
    authorize!
    @house = @season.house
    @season.destroy
    respond_to do |format|
      format.html { redirect_to admin_house_seasons_path(@house.number), notice: 'Season was successfully destroyed.' }
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
