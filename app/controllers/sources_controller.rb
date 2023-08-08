class SourcesController < ApplicationController
  load_and_authorize_resource
  layout 'admin'

  before_action :set_source, only: %i[show edit update destroy]

  # @route GET (/:locale)/sources {locale: nil} (sources)
  def index
    @sources = Source.all
  end

  def show; end

  # @route GET (/:locale)/sources/new {locale: nil} (new_source)
  def new
    @source = Source.new
  end

  # @route GET (/:locale)/sources/:id/edit {locale: nil} (edit_source)
  def edit; end

  # @route POST (/:locale)/sources {locale: nil} (sources)
  def create
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

  # @route PATCH (/:locale)/sources/:id {locale: nil} (source)
  # @route PUT (/:locale)/sources/:id {locale: nil} (source)
  def update
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

  # @route DELETE (/:locale)/sources/:id {locale: nil} (source)
  def destroy
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
