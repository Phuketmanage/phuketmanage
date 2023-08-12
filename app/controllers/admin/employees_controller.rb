class EmployeesController < AdminController
  load_and_authorize_resource

  layout 'admin'
  before_action :set_employee, only: %i[show edit update destroy]

  # @route GET (/:locale)/employees {locale: nil} (employees)
  def index
    @employees = Employee.all
  end

  # @route GET (/:locale)/employees/:id {locale: nil} (employee)
  def show; end

  # @route GET (/:locale)/employees/list_for_job {locale: nil} (employees_list_for_job)
  def list_for_job
    empls = Employee.joins(:houses, :job_types).where(
      'houses.id = ? AND job_types.id = ?',
      params[:house_id], params[:job_type_id]
    )
    # puts "=== Employees === #{empls.inspect}"
    render json: empls.map { |e| { id: e.id, name: e.name, type: e.type.name } }
  end

  # @route GET (/:locale)/employees/new {locale: nil} (new_employee)
  def new
    @employee = Employee.new
  end

  # @route GET (/:locale)/employees/:id/edit {locale: nil} (edit_employee)
  def edit; end

  # @route POST (/:locale)/employees {locale: nil} (employees)
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH (/:locale)/employees/:id {locale: nil} (employee)
  # @route PUT (/:locale)/employees/:id {locale: nil} (employee)
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE (/:locale)/employees/:id {locale: nil} (employee)
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:type_id, :name)
  end
end
