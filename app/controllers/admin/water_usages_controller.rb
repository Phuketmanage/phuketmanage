class WaterUsagesController < AdminController
  load_and_authorize_resource

  before_action :set_water_usage, only: %i[show edit update destroy]

  layout 'admin'

  # @route GET (/:locale)/water_usages {locale: nil} (water_usages)
  def index
    if params[:house_id].present?
      @water_usage = WaterUsage.where(house_id: params[:house_id]).order(date: :desc).first(30)
    else
      @water_usages = WaterUsage.all
      @house_groups = HouseGroup.all
      @houses = House.where(water_reading: true).order(:house_group_id, :code).all
      @water_usage = WaterUsage.new
    end
  end

  # @route GET (/:locale)/water_usages/:id {locale: nil} (water_usage)
  def show; end

  # def new
  #   @water_usage = WaterUsage.new
  # end

  # def edit
  # end

  # @route POST (/:locale)/water_usages {locale: nil} (water_usages)
  def create
    @water_usage = WaterUsage.new(water_usage_params)

    respond_to do |format|
      if @water_usage.save
        format.html { redirect_to @water_usage, notice: 'Water usage was successfully created.' }
        format.json { render :show, status: :created, location: @water_usage }
        format.js
      else
        format.html { render :new }
        format.json { render json: @water_usage.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # @route PATCH (/:locale)/water_usages/:id {locale: nil} (water_usage)
  # @route PUT (/:locale)/water_usages/:id {locale: nil} (water_usage)
  def update
    respond_to do |format|
      if @water_usage.update(water_usage_params)
        format.html do
 redirect_to water_usages_path(house_id: @water_usage.house_id), notice: 'Water usage was successfully updated.' end
        format.json { render :show, status: :ok, location: @water_usage }
      else
        format.html { render :edit }
        format.json { render json: @water_usage.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE (/:locale)/water_usages/:id {locale: nil} (water_usage)
  def destroy
    @water_usage.destroy
    respond_to do |format|
      format.html { redirect_to water_usages_url, notice: 'Water usage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_water_usage
    @water_usage = WaterUsage.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def water_usage_params
    params.require(:water_usage).permit(:house_id, :date, :amount, :amount_2, :comment)
  end
end
