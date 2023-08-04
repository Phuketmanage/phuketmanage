class PagesController < ApplicationController
  # authorize_resource :class => false

  layout 'test', only: :test

  # @route GET (/:locale)/:locale
  # @route GET / (root)
  def index
    @search = Search.new
    @houses = House.where(unavailable: false).order('random()')
    @min_date = @search.min_date
    @locations = Location.all
    @bdrs = House.all.count.positive? ? House.all.pluck(:rooms).sort.uniq : [0]
    @types = HouseType.all
  end

  # @route GET (/:locale)/about (page_about)
  def about; end

  # @route GET /test (test)
  def test; end
end
