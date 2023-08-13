class Admin::LocationsController < ApplicationController
  load_and_authorize_resource id_param: :number

  before_action :set_location, only: %i[show edit update destroy]

  layout 'admin'

  # @route GET (/:locale)/locations {locale: nil} (locations)
  def index
    @locations = Location.all.order(:name_en)
  end

  def show; end

  # @route GET (/:locale)/locations/new {locale: nil} (new_location)
  def new
    @location = Location.new
  end

  # @route GET (/:locale)/locations/:id/edit {locale: nil} (edit_location)
  def edit; end

  # @route POST (/:locale)/locations {locale: nil} (locations)
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to locations_url, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH (/:locale)/locations/:id {locale: nil} (location)
  # @route PUT (/:locale)/locations/:id {locale: nil} (location)
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to locations_url, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE (/:locale)/locations/:id {locale: nil} (location)
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(:name_en, :name_ru, :descr_en, :descr_ru)
  end
end
