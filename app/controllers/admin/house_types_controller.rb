class Admin::HouseTypesController < AdminController
  before_action :set_house_type, only: %i[show edit update destroy]

  # @route GET /house_types (house_types)
  def index
    authorize!
    @house_types = HouseType.all
  end

  # @route GET /house_types/:id (house_type)
  def show
    authorize!
  end

  # @route GET /house_types/new (new_house_type)
  def new
    authorize!
    @house_type = HouseType.new
  end

  # @route GET /house_types/:id/edit (edit_house_type)
  def edit
    authorize!
  end

  # @route POST /house_types (house_types)
  def create
    authorize!
    @house_type = HouseType.new(house_type_params)

    respond_to do |format|
      if @house_type.save
        format.html { redirect_to @house_type, notice: 'House type was successfully created.' }
        format.json { render :show, status: :created, location: @house_type }
      else
        format.html { render :new }
        format.json { render json: @house_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /house_types/:id (house_type)
  # @route PUT /house_types/:id (house_type)
  def update
    authorize!
    respond_to do |format|
      if @house_type.update(house_type_params)
        format.html { redirect_to @house_type, notice: 'House type was successfully updated.' }
        format.json { render :show, status: :ok, location: @house_type }
      else
        format.html { render :edit }
        format.json { render json: @house_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /house_types/:id (house_type)
  def destroy
    authorize!
    @house_type.destroy
    respond_to do |format|
      format.html { redirect_to house_types_url, notice: 'House type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_house_type
    @house_type = HouseType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def house_type_params
    params.require(:house_type).permit(:name_en, :name_ru, :comm)
  end
end
