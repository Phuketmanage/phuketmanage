class Guests::IndexController < GuestsController
  def index
    @search = Search.new
    @min_date = @search.min_date
    @houses = House.includes(:type, :prices, :locations).where(unavailable: false).order('random()').load
    @locations = Location.all
    @bdrs = @houses.pluck(:rooms).uniq.sort
    @types = @houses.map(&:type).uniq
  end
end
