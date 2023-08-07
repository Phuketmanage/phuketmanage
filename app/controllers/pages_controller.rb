class PagesController < ApplicationController
  # authorize_resource :class => false

  layout 'test', only: :test

  # @route GET /(:locale) {locale: nil} (locale_root)
  # @route GET / (root)
  def index
    @search = Search.new
    @houses = House.where(unavailable: false).order('random()')
    @min_date = @search.min_date
    @locations = Location.all
    @bdrs = House.where.not(rooms: nil).select(:rooms).distinct.pluck(:rooms).sort
    @types = HouseType.all
  end

  # @route GET (/:locale)/about {locale: nil} (page_about)
  def about; end

  # @route GET (/:locale)/test {locale: nil} (test)
  def test; end
end
