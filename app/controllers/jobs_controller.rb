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
    @status = params[:status]
    if current_user.role? :admin
      jt_id = JobType.find_by(name: 'For management').id
      @jobs = Job.where(job_type_id: jt_id).order(updated_at: :desc)
    else
      @jobs = current_user.jobs.order(updated_at: :desc)
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
      @laundry = Job.joins(:job_type).where('job_types.code IN (?,?,?) AND (
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

  def job_order
    if !params[:from].present? || !params[:to].present?
      #need to return error message
    elsif params[:from].present? && params[:to].present?
      from = params[:from].to_date
      to = params[:to].to_date
    end
    jobs_raw = []
    if params[:house].present?
      house = params[:house]
      jobs_raw = House.find_by(number: house).jobs
                    .where('plan >= ? AND plan <= ?', from, to)
                    .order(:plan, :time)
    else
      hidden_houses1 = hidden_houses2 = []
      hidden_houses1 = params[:hidden_houses].split(',').reject(&:empty?)
      if !params[:hidden_groups].nil?
        hidden_houses2 = House.where(house_group_id: params[:hidden_groups]).ids
      end
      hidden_houses = (hidden_houses1+hidden_houses2).uniq
      jobs_raw = Job.where.not(house_id: nil)
                    .where.not(house_id: hidden_houses)
                    .where('plan >= ? AND plan <= ?', from, to)
                    .order(:plan, :time)
    end
    jobs = {}
    date_old = ''
    jobs_raw.each do |j|
      date = j.plan.strftime('%d.%m.%Y')
      if date != date_old
        jobs[date] = []
        # jobs[date]['date'] = date
        # jobs[date]['jobs'] = []
        jobs[date] << ["#{j.time} #{j.house.code} #{j.job_type.name} #{'<span class="remarks">[Paid by tenant]</span>' j.paid_by_tenant == true}"]
        date_old = date
      else
        jobs[date] << ["#{j.time} #{j.house.code} #{j.job_type.name} #{'<span class="remarks">[Paid by tenant]</span>' j.paid_by_tenant == true}"]
      end

    end
    render json: { jobs:  jobs }
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @message = JobMessage.new
    @messages = @job.job_messages.last(10)
    # @s3_direct_post = S3_BUCKET.presigned_post(key: "job_messages/#{@job.id}/${filename}", success_action_status: '201', acl: 'public-read')
    @s3_direct_post = S3_BUCKET.presigned_post(
      key: "job_messages/#{@job.id}/${filename}",
      success_action_status: '201',
      acl: 'public-read',
      content_type_starts_with: "")
    trace = @job.job_tracks.where(user_id: current_user.id)
    if trace.any?
      trace.update(visit_time: Time.zone.now)
    else
      @job.job_tracks.create!(user_id: current_user.id, visit_time: Time.zone.now)
    end

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
        format.html { redirect_to job_path(@job), notice: 'Job was successfully updated.' }
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
                                  :status,
                                  :paid_by_tenant )
    end
end
