class Guests::IndexController < GuestsController
  def index
    @search = Search.new
    @min_date = @search.min_date
    @houses = House.includes(:type, :prices, :locations).where(unavailable: false).order('random()').load
    @locations = Location.all
    @bdrs = @houses.pluck(:rooms).compact.uniq.sort
    @types = HouseType.all
  end
end
