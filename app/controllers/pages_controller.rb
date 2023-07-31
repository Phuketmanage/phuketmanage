class PagesController < ApplicationController
  # authorize_resource :class => false

  layout 'test', only: :test

  # @route GET (/:locale)/:locale
  # @route GET / (root)
  def index
    @search = Search.new
    @houses = House.where(unavailable: false).order('random()')
    @min_date = @search.min_date
    @locations = Location.all.map { |location| location.send("name_#{I18n.locale}") }
    @bdrs = House.all.count > 0 ? House.all.pluck(:rooms).sort.uniq : [0]
    @types = HouseType.all.map { |type| type.send("name_#{I18n.locale}") }
  end

  # @route GET (/:locale)/about (page_about)
  def about; end

  # @route GET /test (test)
  def test; end
end
