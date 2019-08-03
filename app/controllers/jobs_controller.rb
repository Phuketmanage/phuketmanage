class JobsController < ApplicationController
  load_and_authorize_resource

  before_action :set_job, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  # GET /jobs
  # GET /jobs.json
  def index
    @job = Job.new
    if current_user.role? :admin
      maids = User.with_role('Maid').ids
      if params[:closed].present?
        @jobs = Job.where.not(user_id: maids, closed: nil).order(closed: :desc)
      else
        @jobs = Job.where(closed: nil).where.not(user_id: maids).order(:plan)
      end
    else
      if params[:closed].present?
        @jobs = current_user.jobs.where.not(closed: nil).order(closed: :desc)
      else
        @jobs = current_user.jobs.where(closed: nil).order(:plan)
      end
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
    @job.creator_id = current_user.id
    respond_to do |format|
      if @job.save
        format.html { redirect_to jobs_path, notice: 'Job was successfully created.' }
        format.json { render  json: { job: {
                                        id: @job.id,
                                        type_id: @job.job_type.id
                                        code: @job.job_type.code,
                                        color: @job.job_type.color,
                                        time: @job.time,
                                        job: @job.job
                                        employee_id: @job.employee.id
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
    if params[:done].present?
      @job_status_toggled = true
      @job.closed = Time.zone.now if params[:done] == 'true'
      @job.closed = nil if params[:done] == 'false'
      @job.save
      return
    end

    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to jobs_path, notice: 'Job was successfully updated.' }
        format.json { render :index, status: :ok, location: @job }
        format.js
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
