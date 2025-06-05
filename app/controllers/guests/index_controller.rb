class Guests::IndexController < GuestsController
  # @route GET / (root)
  # @route GET /(:locale) (guests_locale_root)
  def index
    redirect_to new_user_session_path unless Rails.env.test?
    
    @search = Search.new
    @min_date = @search.min_date
    @houses = House.includes(:type, :prices, :locations).where(unavailable: false).order('random()').load
    @locations = Location.all
    @bdrs = @houses.pluck(:rooms).compact.uniq.sort
    @types = HouseType.all
  end
end
