class HousesController < ApplicationController
  load_and_authorize_resource

  before_action :set_house, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def ical

    respond_to do |format|
        format.html
        format.ics do
          cal = Icalendar::Calendar.new
          cal.x_wr_calname = 'Awesome Rails Calendar'
          cal.event do |e|
            e.dtstart     = DateTime.now + 2.days
            e.dtend       = DateTime.now + 20.days
            e.summary     = "Meeting with the man."
            e.description = "Have a long lunch meeting and decide nothing..."
          end
          cal.publish
          # render text: cal.to_ical #, content_type: 'text/calendar'
          render text: cal.to_ical
        end
    end
  end


  # GET /houses
  # GET /houses.json
  def index
    @houses = House.all.order(:unavailable, :code)
  end

  # GET /houses/1
  # GET /houses/1.json
  def show
  end

  # GET /houses/new
  def new
    @house = House.new
    @owners = User.with_role('Owner')
    @types = HouseType.all
  end

  # GET /houses/1/edit
  def edit
    @owners = User.with_role('Owner')
    @types = HouseType.all
  end

  # POST /houses
  # POST /houses.json
  def create
    @house = House.new(house_params)

    respond_to do |format|
      if @house.save
        format.html { redirect_to houses_path, notice: 'House was successfully created.' }
        format.json { render :show, status: :created, location: @house }
      else
        @owners = User.with_role('Owner')
        @types = HouseType.all
        format.html { render :new }
        format.json { render json: @house.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /houses/1
  # PATCH/PUT /houses/1.json
  def update
    respond_to do |format|
      if @house.update(house_params)
        format.html { redirect_to houses_path, notice: 'House was successfully updated.' }
        format.json { render :show, status: :ok, location: @house }
      else
        @owners = User.with_role('Owner')
        @types = HouseType.all
        format.html { render :edit }
        format.json { render json: @house.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /houses/1
  # DELETE /houses/1.json
  def destroy
    @house.destroy
    respond_to do |format|
      format.html { redirect_to houses_url, notice: 'House was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_house
      @house = House.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def house_params
      params.require(:house).permit(
                                    :code,
                                    :title_en,
                                    :title_ru,
                                    :description_en,
                                    :description_ru,
                                    :owner_id,
                                    :type_id,
                                    :size,
                                    :plot_size,
                                    :rooms,
                                    :bathrooms,
                                    :pool,
                                    :pool_size,
                                    :communal_pool,
                                    :parking,
                                    :parking_size,
                                    :unavailable
                                    )
    end
end
