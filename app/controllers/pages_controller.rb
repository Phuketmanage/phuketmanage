class PagesController < ApplicationController
  # authorize_resource :class => false

  layout 'test', only: :test

  # @route GET (/:locale)/:locale
  # @route GET / (root)
  def index
    @search = Search.new
    @houses = House.where(unavailable: false).order('random()')
  end

  # @route GET (/:locale)/about (page_about)
  def about; end

  # @route GET /test (test)
  def test
  end
end
