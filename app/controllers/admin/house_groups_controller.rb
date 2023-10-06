class Admin::HouseGroupsController < AdminController
  before_action :set_house_group, only: %i[show edit update destroy]

  # @route GET /house_groups (house_groups)
  def index
    authorize!
    @house_groups = HouseGroup.all
  end

  # @route GET /house_groups/:id (house_group)
  def show
    authorize!
  end

  # @route GET /house_groups/new (new_house_group)
  def new
    authorize!
    @house_group = HouseGroup.new
  end

  # @route GET /house_groups/:id/edit (edit_house_group)
  def edit
    authorize!
  end

  # @route POST /house_groups (house_groups)
  def create
    authorize!
    @house_group = HouseGroup.new(house_group_params)

    respond_to do |format|
      if @house_group.save
        format.html { redirect_to @house_group, notice: 'House group was successfully created.' }
        format.json { render :show, status: :created, location: @house_group }
      else
        format.html { render :new }
        format.json { render json: @house_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /house_groups/:id (house_group)
  # @route PUT /house_groups/:id (house_group)
  def update
    authorize!
    respond_to do |format|
      if @house_group.update(house_group_params)
        format.html { redirect_to @house_group, notice: 'House group was successfully updated.' }
        format.json { render :show, status: :ok, location: @house_group }
      else
        format.html { render :edit }
        format.json { render json: @house_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /house_groups/:id (house_group)
  def destroy
    authorize!
    @house_group.destroy
    respond_to do |format|
      format.html { redirect_to house_groups_url, notice: 'House group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_house_group
    @house_group = HouseGroup.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def house_group_params
    params.require(:house_group).permit(:name)
  end
end
