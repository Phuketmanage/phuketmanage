class Admin::SearchController < Admin::AdminController
  include Admin::SearchHelper
  before_action :perform_search
  verify_authorized except: :index

  # @route GET /search (search)
  def index
    redirect_to generated_link_to_guests_search and return unless allowed_to?(:index?)
    authorize!
    @min_date = @search.min_date
    @houses = []
    @locations = Location.all
    @bdrs      = House.for_rent.select('DISTINCT(houses.rooms), houses.code').pluck(:rooms).sort
    @types     = HouseType.all
    render :index and return unless params[:search].present? && @search.valid?

    # This controller is accesed by managment, so Management can see prices even for occupied houses
    # management = true if user_signed_in? && current_user.role?(%w[Admin Manager Accounting])
    management = true
    get_houses = @search.get_available_houses(management)
    @houses = get_houses[:available]
    @unavailable_houses = get_houses[:unavailable_ids]
    @prices = @search.get_prices @houses, @unavailable_houses
  end

  private

  def perform_search
    @search = if params[:search].blank?
      Search.new
    else
      Search.new(search_params)
    end
  end

  def search_params
    params.require(:search).permit(:period, type: [], bdr: [], location: []).merge(dtnb: @settings['dtnb'])
  end
end
