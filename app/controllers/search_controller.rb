class SearchController < ApplicationController
  # @route GET (/:locale)/search (search)
  def index
    @search = Search.new(period: params['search']['period'], dtnb: @settings['dtnb'])
    @min_date = @search.min_date
    @houses = []
    render :index and return unless @search.valid?

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
    params.require(:search).permit(:stage, :rs, :rf)
  end
end
