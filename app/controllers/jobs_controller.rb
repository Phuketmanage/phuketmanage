class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  # GET /jobs
  # GET /jobs.json
  def index
    if current_user.role? :admin
      @jobs = Job.all
    else
      @jobs = current_user.jobs
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)
    respond_to do |format|
      if @job.save
        format.html { redirect_to jobs_path, notice: 'Job was successfully created.' }
        format.json { render  json: { job: {
                                        id: @job.id,
                                        code: @job.job_type.code,
                                        color: @job.job_type.color,
                                        time: @job.time,
                                        job: @job.job
                                      },
                                      cell_id: params[:cell_id]
                                    },
                              status: :ok }
      else
        format.html { render  :new }
        format.json { render  json: @job.errors,
                              status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to jobs_path, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:job_type_id, :user_id, :booking_id, :house_id, :date, :time, :plan, :closed, :job, :comment )
    end
end
