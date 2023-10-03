class Admin::SourcesController < AdminController
  verify_authorized
  before_action :set_source, only: %i[show edit update destroy]

  # @route GET /sources (sources)
  def index
    authorize!
    @sources = Source.all
  end

  def show
    authorize!
  end

  # @route GET /sources/new (new_source)
  def new
    authorize!
    @source = Source.new
  end

  # @route GET /sources/:id/edit (edit_source)
  def edit
    authorize!
  end

  # @route POST /sources (sources)
  def create
    authorize!
    @source = Source.new(source_params)

    respond_to do |format|
      if @source.save
        format.html { redirect_to sources_url, notice: 'Source was successfully created.' }
        format.json { render :show, status: :created, location: @source }
      else
        format.html { render :new }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH /sources/:id (source)
  # @route PUT /sources/:id (source)
  def update
    authorize!
    respond_to do |format|
      if @source.update(source_params)
        format.html { redirect_to sources_url, notice: 'Source was successfully updated.' }
        format.json { render :show, status: :ok, location: @source }
      else
        format.html { render :edit }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /sources/:id (source)
  def destroy
    authorize!
    Booking.where(source_id: @source.id).update_all(source_id: nil)
    @source.destroy

    respond_to do |format|
      format.html { redirect_to sources_url, notice: 'Source was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_source
    @source = Source.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def source_params
    params.require(:source).permit(:name, :syncable)
  end
end
