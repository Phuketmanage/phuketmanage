class Admin::OptionsController < AdminController
  verify_authorized
  before_action :set_option, only: %i[show edit update destroy]

  # @route GET /options (options)
  def index
    authorize!
    @options = Option.order(:zindex).all
  end

  def show
    authorize!
  end

  # @route GET /options/new (new_option)
  def new
    authorize!
    @option = Option.new
  end

  # @route GET /options/:id/edit (edit_option)
  def edit
    authorize!
  end

  # @route POST /options (options)
  def create
    authorize!
    @option = Option.new(option_params)

    respond_to do |format|
      if @option.save
        format.html { redirect_to options_path, notice: 'Option was successfully created.' }
        format.json { render :show, status: :created, location: @option }
      else
        format.html { render :new }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /options/:id (option)
  # @route PUT /options/:id (option)
  def update
    authorize!
    respond_to do |format|
      if @option.update(option_params)
        format.html { redirect_to options_path, notice: 'Option was successfully updated.' }
        format.json { render :show, status: :ok, location: @option }
      else
        format.html { render :edit }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /options/:id (option)
  def destroy
    authorize!
    @option.destroy
    respond_to do |format|
      format.html { redirect_to options_url, notice: 'Option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_option
    @option = Option.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def option_params
    params.require(:option).permit(:title_en, :title_ru, :zindex)
  end
end
