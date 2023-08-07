class OptionsController < ApplicationController
  load_and_authorize_resource id_param: :number

  before_action :set_option, only: %i[show edit update destroy]

  layout 'admin'

  # @route GET (/:locale)/options {locale: nil} (options)
  def index
    @options = Option.order(:zindex).all
  end

  def show; end

  # @route GET (/:locale)/options/new {locale: nil} (new_option)
  def new
    @option = Option.new
  end

  # @route GET (/:locale)/options/:id/edit {locale: nil} (edit_option)
  def edit; end

  # @route POST (/:locale)/options {locale: nil} (options)
  def create
    @option = Option.new(option_params)

    respond_to do |format|
      if @option.save
        format.html { redirect_to options_path, notice: 'Option was successfully created.' }
        format.json { render :show, status: :created, location: @option }
      else
        format.html { render :new }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route PATCH (/:locale)/options/:id {locale: nil} (option)
  # @route PUT (/:locale)/options/:id {locale: nil} (option)
  def update
    respond_to do |format|
      if @option.update(option_params)
        format.html { redirect_to options_path, notice: 'Option was successfully updated.' }
        format.json { render :show, status: :ok, location: @option }
      else
        format.html { render :edit }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE (/:locale)/options/:id {locale: nil} (option)
  def destroy
    @option.destroy
    respond_to do |format|
      format.html { redirect_to options_url, notice: 'Option was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_option
    @option = Option.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def option_params
    params.require(:option).permit(:title_en, :title_ru, :zindex)
  end
end
