class Admin::SettingsController < ApplicationController
  load_and_authorize_resource

  before_action :set_setting, only: %i[show edit update destroy]
  layout 'admin'
  # @route GET /settings (settings)
  def index
    @settings = Setting.all
  end

  # @route GET /settings/:id (setting)
  def show; end

  # @route GET /settings/new (new_setting)
  def new
    @setting = Setting.new
  end

  # @route GET /settings/:id/edit (edit_setting)
  def edit; end

  # @route POST /settings (settings)
  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Setting was successfully created.' }
        format.json { render :show, status: :created, location: @setting }
      else
        format.html { render :new }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /settings/:id (setting)
  # @route PUT /settings/:id (setting)
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /settings/:id (setting)
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url, notice: 'Setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_setting
    @setting = Setting.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def setting_params
    params.require(:setting).permit(:var, :value, :description)
  end
end
