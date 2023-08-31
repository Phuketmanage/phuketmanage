class Admin::SearchController < AdminController
  authorize_resource class: false

  # @route GET /search (search)
  def index
    @search = Search.new(period: params.dig('search', 'period'), type: params.dig('search', 'type'),
                         bdr: params.dig('search', 'bdr'), location: params.dig('search', 'location'), dtnb: @settings['dtnb'])
    @min_date = @search.min_date
    @houses = []
    @locations = Location.all
    @bdrs = House.where.not(rooms: nil).select(:rooms).distinct.pluck(:rooms).sort
    @types = HouseType.all

    # Management can see prices even for occupied houses
    management = false
    management = true if user_signed_in? && current_user.role?(%w[Admin Manager Accounting])
    get_houses = @search.get_available_houses(management)
    @houses = get_houses[:available]
    @unavailable_houses = get_houses[:unavailable_ids]
    @prices = @search.get_prices @houses, @unavailable_houses
  end

  private

  def search_params
    params.require(:search).permit(:stage, :period, :type, :bdr, :location)
  end
end
