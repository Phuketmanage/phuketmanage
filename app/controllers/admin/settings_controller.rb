class Admin::SettingsController < AdminController
  verify_authorized
  before_action :set_setting, only: %i[show edit update destroy]

  # @route GET /settings (settings)
  def index
    authorize!
    @settings = Setting.all
  end

  # @route GET /settings/:id (setting)
  def show
    authorize!
  end

  # @route GET /settings/new (new_setting)
  def new
    authorize!
    @setting = Setting.new
  end

  # @route GET /settings/:id/edit (edit_setting)
  def edit
    authorize!
  end

  # @route POST /settings (settings)
  def create
    authorize!
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
    authorize!
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
    authorize!
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
