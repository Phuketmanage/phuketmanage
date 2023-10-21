class Admin::WaterUsagesController < AdminController
  before_action :set_water_usage, only: %i[show edit update destroy]

  # @route GET /water_usages (water_usages)
  def index
    authorize!
    if params[:house_id].present?
      @water_usage = WaterUsage.active.where(house_id: params[:house_id]).order(date: :desc).first(30)
    else
      @water_usages = WaterUsage.all
      @house_groups = HouseGroup.all
      @houses = House.active.where(water_reading: true).order(:house_group_id, :code).all
      @water_usage = WaterUsage.new
    end
  end

  # @route GET /water_usages/:id (water_usage)
  def show
    authorize!
  end

  # def new
  #   @water_usage = WaterUsage.new
  # end

  # def edit
  # end

  # @route POST /water_usages (water_usages)
  def create
    authorize!
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

  # @route PATCH /water_usages/:id (water_usage)
  # @route PUT /water_usages/:id (water_usage)
  def update
    authorize!
    respond_to do |format|
      if @water_usage.update(water_usage_params)
        format.html do
          redirect_to water_usages_path(house_id: @water_usage.house_id),
                      notice: 'Water usage was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @water_usage }
      else
        format.html { render :edit }
        format.json { render json: @water_usage.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /water_usages/:id (water_usage)
  def destroy
    authorize!
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
