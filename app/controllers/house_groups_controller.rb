class HouseGroupsController < ApplicationController
  load_and_authorize_resource id_param: :number

  before_action :set_house_group, only: [:show, :edit, :update, :destroy]

  layout 'admin'


  # GET /house_groups
  # GET /house_groups.json
  def index
    @house_groups = HouseGroup.all
  end

  # GET /house_groups/1
  # GET /house_groups/1.json
  def show
  end

  # GET /house_groups/new
  def new
    @house_group = HouseGroup.new
  end

  # GET /house_groups/1/edit
  def edit
  end

  # POST /house_groups
  # POST /house_groups.json
  def create
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

  # PATCH/PUT /house_groups/1
  # PATCH/PUT /house_groups/1.json
  def update
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

  # DELETE /house_groups/1
  # DELETE /house_groups/1.json
  def destroy
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
