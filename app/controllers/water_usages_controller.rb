class WaterUsagesController < ApplicationController
  load_and_authorize_resource

  before_action :set_water_usage, only: [:show, :edit, :update, :destroy]

  layout 'admin'

  # GET /water_usages
  # GET /water_usages.json
  def index
    if params[:house_id].present?
      @water_usage = WaterUsage.where(house_id: params[:house_id]).order(date: :desc).last(30)

    else
      @water_usages = WaterUsage.all
      @house_groups = HouseGroup.all
      @houses = House.where(water_reading: true).order(:house_group_id, :code).all
      @water_usage = WaterUsage.new
    end

  end

  # GET /water_usages/1
  # GET /water_usages/1.json
  def show
  end

  # GET /water_usages/new
  # def new
  #   @water_usage = WaterUsage.new
  # end

  # GET /water_usages/1/edit
  # def edit
  # end

  # POST /water_usages
  # POST /water_usages.json
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

  # PATCH/PUT /water_usages/1
  # PATCH/PUT /water_usages/1.json
  def update
    respond_to do |format|
      if @water_usage.update(water_usage_params)
        format.html { redirect_to water_usages_path(house_id: @water_usage.house_id), notice: 'Water usage was successfully updated.' }
        format.json { render :show, status: :ok, location: @water_usage }
      else
        format.html { render :edit }
        format.json { render json: @water_usage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /water_usages/1
  # DELETE /water_usages/1.json
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
      params.require(:water_usage).permit(:house_id, :date, :amount, :amount_2)
    end
end
