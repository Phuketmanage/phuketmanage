class Guests::SearchController < ApplicationController
  before_action :check_search_params

  def index
    @search = Search.new(period: search_params['period'], type: search_params['type'],
                         bdr: search_params['bdr'], location: search_params['location'], dtnb: @settings['dtnb'])
    @min_date = @search.min_date
    @houses = []
    @locations = Location.all
    @bdrs = House.where.not(rooms: nil).select(:rooms).distinct.pluck(:rooms).sort
    @types = HouseType.all
    render :index and return unless @search.valid?

    @houses = @search.get_available_houses(false)[:available]
    @prices = @search.get_prices @houses
  end

  private

  def check_search_params
    return if params[:search].present?

    redirect_to locale_root_path
  end

  def search_params
    params.require(:search).permit(:stage, :period, :type, :bdr, :location)
  end
end
