class Admin::JobTypesController < AdminController
  load_and_authorize_resource

  before_action :set_job_type, only: %i[show edit update destroy]

  # @route GET /job_types (job_types)
  def index
    @job_types = JobType.all
  end

  def show; end

  # @route GET /job_types/new (new_job_type)
  def new
    @job_type = JobType.new
  end

  # @route GET /job_types/:id/edit (edit_job_type)
  def edit; end

  # @route POST /job_types (job_types)
  def create
    @job_type = JobType.new(job_type_params)

    respond_to do |format|
      if @job_type.save
        format.html { redirect_to job_types_path, notice: 'Job type was successfully created.' }
        format.json { render :show, status: :created, location: @job_type }
      else
        format.html { render :new }
        format.json { render json: @job_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /job_types/:id (job_type)
  # @route PUT /job_types/:id (job_type)
  def update
    respond_to do |format|
      if @job_type.update(job_type_params)
        format.html { redirect_to job_types_path, notice: 'Job type was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_type }
      else
        format.html { render :edit }
        format.json { render json: @job_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /job_types/:id (job_type)
  def destroy
    @job_type.destroy
    respond_to do |format|
      format.html { redirect_to job_types_url, notice: 'Job type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_job_type
    @job_type = JobType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_type_params
    params.require(:job_type).permit(:name, :code, :color, :for_house_only, { empl_type_ids: [] })
  end
end
