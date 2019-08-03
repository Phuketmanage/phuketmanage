class EmplTypesController < ApplicationController
  layout 'admin'
  before_action :set_empl_type, only: [:show, :edit, :update, :destroy]

  # GET /empl_types
  # GET /empl_types.json
  def index
    @empl_types = EmplType.all
  end

  # GET /empl_types/1
  # GET /empl_types/1.json
  def show
  end

  # GET /empl_types/new
  def new
    @empl_type = EmplType.new
  end

  # GET /empl_types/1/edit
  def edit
  end

  # POST /empl_types
  # POST /empl_types.json
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

  # PATCH/PUT /empl_types/1
  # PATCH/PUT /empl_types/1.json
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

  # DELETE /empl_types/1
  # DELETE /empl_types/1.json
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
