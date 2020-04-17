class JobsController < ApplicationController
  load_and_authorize_resource

  before_action :set_job, only: [:show, :edit, :update, :update_laundry, :destroy]
  after_action :system_message_create, only: [:create]
  after_action :system_message_update, only: [:update]
  layout 'admin'

  # GET /jobs
  # GET /jobs.json
  def index
    @job = Job.new
    @message = JobMessage.new
    @status = params[:status]
    if current_user.role? :admin
      maids = User.with_role('Maid').ids
      @jobs = Job.where.not(user_id: nil).order(updated_at: :desc)
    else
      @jobs = current_user.jobs.order(updated_at: :desc)
    end
    @messages = []
    if params['job_id'].present?
      @active_job = Job.find(params['job_id'])
      @messages = @active_job.job_messages.last(10)
      @s3_direct_post = S3_BUCKET.presigned_post(key: "job_messages/#{@active_job.id}/${filename}", success_action_status: '201', acl: 'public-read')
    end
  end

  def index_new
    maids = EmplType.find_by(name: 'Maids').employees.ids
    @jobs = Job.where(closed: nil, employee_id: maids).order(:plan)
    # @jobs = Job.where(closed: nil).order(:plan)
    @for = :maids
    render :index
  end

  def laundry
    from = params[:from]
    to = params[:to]
    if !from.present? && !to.present?
      @laundry = Job.joins(:job_type).where('job_types.code IN (?,?,?) AND (
                                          collected IS NULL OR
                                          sent IS NULL OR
                                          rooms IS NULL OR
                                          price IS NULL)', 'B', 'X', 'L')
                                    .order(:plan)
    elsif from.present? && !to.present? || !from.present? && to.present?
      @error_message = "Both dates should be selected / ควรเลือกวันที่ทั้งสอง"
      @laundry = Job.joins(:job_type).where('job_types.code IN (?,?) AND (
                                          collected IS NULL OR
                                          sent IS NULL OR
                                          rooms IS NULL OR
                                          price IS NULL)', 'B', 'X', 'L')
                                    .order(:plan)
    elsif from.present? && to.present?
      from = from.to_date
      to = to.to_date
      @laundry = Job.joins(:job_type).where('job_types.code IN (?,?,?) AND
                            plan >= ? AND plan <= ?', 'B', 'X', 'L', from, to)
                                    .order(:plan)

    end

  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show

  end

  # GET /jobs/new
  def new
    @job = Job.new
    @houses = House.all.order(:code)

  end

  # GET /jobs/1/edit
  def edit
    @houses = House.all.order(:code)
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
                                        type_id: @job.job_type.id,
                                        code: @job.job_type.code,
                                        color: @job.job_type.color,
                                        time: @job.time,
                                        job: @job.job,
                                        employee_id: @job.employee_id
                                      },
                                      cell_id: params[:cell_id]
                                    },
                              status: :ok }
      else
        @houses = House.all.order(:code)
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
        format.html { redirect_to jobs_path(job_id: @job.id), notice: 'Job was successfully updated.' }
        format.json { render :index, status: :ok, location: @job }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_laundry
    @job.update(job_params)
    redirect_to laundry_path
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

    def system_message_create
      @job.job_messages.create!(sender: current_user,
        message: "Job created",
        is_system: 1)
    end

    def system_message_update
      changes = @job.saved_changes
      changes.each do |key, value|
        unless key == "updated_at"
          @job.job_messages.create!(sender: current_user,
            message: "#{key} changed: #{value[0]} -> #{value[1]}",
            is_system: 1)
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:job_type_id,
                                  :user_id,
                                  :booking_id,
                                  :house_id,
                                  :date,
                                  :time,
                                  :plan,
                                  :closed,
                                  :job,
                                  :comment,
                                  :employee_id,
                                  :collected,
                                  :sent,
                                  :rooms,
                                  :price,
                                  :status )
    end
end
