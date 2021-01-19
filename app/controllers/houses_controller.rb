class HousesController < ApplicationController
  load_and_authorize_resource id_param: :number

  before_action :set_house, only: [ :show, :edit, :update, :destroy,
                                    :create_connection]
  layout 'admin', except: :show

  # GET /houses
  # GET /houses.json
  def index
    @houses = House.all.order(:unavailable, :code)
    # respond_to do |format|
    #   format.html
      # format.json {render json: {houses: @houses}}
    # end
  end

  def test_upload
    @house = House.new
  end

  # GET /houses/1
  # GET /houses/1.json
  def show
    # Front end

    if params[:rs].present? && params[:rf].present?
      @search = Search.new( rs: params[:rs],
                            rf: params[:rf],
                            dtnb: @settings['dtnb'])
      @houses = [@house]

      @prices = @search.get_prices @houses
      @booking = Booking.new
    else
      @search = Search.new
    end


  end

  # GET /houses/new
  def new
    @house = House.new
    @owners = User.with_role('Owner')
    @types = HouseType.all
    @sources = Source.syncable.order(:name)
    @connections = @house.connections.all
    @connection = @house.connections.new
    @job_types = JobType.all
  end

  # GET /houses/1/edit
  def edit
    @owners = User.with_role('Owner')
    @types = HouseType.all
    @sources = Source.syncable.order(:name)
    @connections = @house.connections.all
    @connection = @house.connections.new
  end

  # POST /houses
  # POST /houses.json
  def create
    options = params[:options] ? params[:options] : nil
    @house = House.new(house_params)
    number_unique = false
    until number_unique do
      number = (('1'..'9').to_a).shuffle[0..rand(1..6)].join
      house = House.find_by(number: number)
      number_unique = true if house.nil?
    end
    @house.number = number
    @house.secret = SecureRandom.hex(16)
    respond_to do |format|
      if @house.save
        format.html { redirect_to houses_path, notice: 'House was successfully created.' }
        format.json { render :show, status: :created, location: @house }
      else
        @owners = User.with_role('Owner')
        @types = HouseType.all
        @sources = Source.syncable.order(:name)
        @connections = @house.connections.all
        @connection = @house.connections.new
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
        if params[:copy_options]
        end
        format.html { redirect_to edit_house_path(@house.number), notice: 'House was successfully updated.' }
        format.json { render :show, status: :ok, location: @house }
      else
        @owners = User.with_role('Owner')
        @types = HouseType.all
        @connections = @house.connections.all
        @connection = @house.connections.new
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
      @house = House.find_by(number: params[:id])
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
                                    :unavailable,
                                    :rental,
                                    :maintenance,
                                    :outsource_cleaning,
                                    :outsource_linen,
                                    :address,
                                    :google_map,
                                    { employee_ids: [] },
                                    :image,
                                    :capacity,
                                    :seaview,
                                    :kingBed,
                                    :queenBed,
                                    :singleBed,
                                    :priceInclude_en,
                                    :priceInclude_ru,
                                    :cancellationPolicy_en,
                                    :cancellationPolicy_ru,
                                    { option_ids: [] },
                                    { location_ids: [] },
                                    :rules_en,
                                    :rules_ru,
                                    :other_en,
                                    :other_ru,
                                    :details,
                                    :house_group_id,
                                    :water_meters,
                                    :water_reading
                                    )
    end

end
