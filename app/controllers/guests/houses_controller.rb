class Guests::HousesController < GuestsController
  before_action :check_search_params, only: :index
  before_action :set_house, :search, only: :show

  # @route GET (/:locale)/houses {locale: nil} (guests_houses)
  def index
    @search = Search.new(period: search_params['period'], type: search_params['type'],
                         bdr: search_params['bdr'], location: search_params['location'], dtnb: @settings['dtnb'])
    @houses = []
    @locations = Location.all
    @bdrs = House.where.not(rooms: nil).select(:rooms).distinct.pluck(:rooms).sort
    @types = HouseType.all
    render :index and return unless @search.valid?

    @houses = @search.get_available_houses(false)[:available]
    @prices = @search.get_prices @houses
  end

  # @route GET (/:locale)/houses/:id {locale: nil} (guests_house)
  def show
    @occupied_days = @house.occupied_days(@settings['dtnb'])
    @min_date = @search.min_date
  end

  private

  def check_search_params
    return if params[:search].present?

    redirect_to guests_locale_root_path
  end

  def search
    if params[:period].blank?
      @search = Search.new
    else
      preform_search
    end
  end

  def preform_search
    @search = Search.new(period: params[:period], dtnb: @settings['dtnb'])

    return unless @search.valid?

    answer = @search.is_house_available? @house.id
    if answer[:result]
      @houses = [@house]
      @prices = @search.get_prices @houses
      @booking = Booking.new
    else
      @prices = "unavailable"
    end
  end

  def set_house
    @house = House.find_by!(number: params[:id])
  end

  def search_params
    params.require(:search).permit(:period, type: [], bdr: [], location: [])
  end
end
