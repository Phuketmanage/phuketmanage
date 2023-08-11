# TODO: Remove after #353

class UploadsTestsController < ApplicationController
  before_action :set_uploads_test, only: %i[ show edit update destroy ]

  # GET /uploads_tests or /uploads_tests.json
  def index
    @uploads_tests = UploadsTest.all
  end

  # GET /uploads_tests/1 or /uploads_tests/1.json
  def show
  end

  # GET /uploads_tests/new
  def new
    @uploads_test = UploadsTest.new
  end

  # GET /uploads_tests/1/edit
  def edit
  end

  # POST /uploads_tests or /uploads_tests.json
  def create
    @uploads_test = UploadsTest.new(uploads_test_params)

    respond_to do |format|
      if @uploads_test.save
        format.html { redirect_to uploads_test_url(@uploads_test), notice: "Uploads test was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploads_tests/1 or /uploads_tests/1.json
  def update
    respond_to do |format|
      if @uploads_test.update(uploads_test_params)
        format.html { redirect_to uploads_test_url(@uploads_test), notice: "Uploads test was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads_tests/1 or /uploads_tests/1.json
  def destroy
    @uploads_test.destroy

    respond_to do |format|
      format.html { redirect_to uploads_tests_url, notice: "Uploads test was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_uploads_test
      @uploads_test = UploadsTest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def uploads_test_params
      params.require(:uploads_test).permit(images: [])
    end
end
