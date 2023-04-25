class EmplTypesController < ApplicationController
  load_and_authorize_resource

  layout 'admin'
  before_action :set_empl_type, only: [:show, :edit, :update, :destroy]

  # @route GET /empl_types (empl_types)
  def index
    @empl_types = EmplType.all
  end

  # @route GET /empl_types/:id (empl_type)
  def show
  end

  # @route GET /empl_types/new (new_empl_type)
  def new
    @empl_type = EmplType.new
  end

  # @route GET /empl_types/:id/edit (edit_empl_type)
  def edit
  end

  # @route POST /empl_types (empl_types)
  def create
    @empl_type = EmplType.new(empl_type_params)

    respond_to do |format|
      if @empl_type.save
        format.html { redirect_to @empl_type, notice: 'Empl type was successfully created.' }
        format.json { render :show, status: :created, location: @empl_type }
      else
        format.html { render :new }
        format.json { render json: @empl_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /empl_types/:id (empl_type)
  # @route PUT /empl_types/:id (empl_type)
  def update
    respond_to do |format|
      if @empl_type.update(empl_type_params)
        format.html { redirect_to @empl_type, notice: 'Empl type was successfully updated.' }
        format.json { render :show, status: :ok, location: @empl_type }
      else
        format.html { render :edit }
        format.json { render json: @empl_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /empl_types/:id (empl_type)
  def destroy
    @empl_type.destroy
    respond_to do |format|
      format.html { redirect_to empl_types_url, notice: 'Empl type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_empl_type
      @empl_type = EmplType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def empl_type_params
      params.require(:empl_type).permit(:name)
    end
end
