class PagesController < ApplicationController

  layout 'test', only: :test

  def index
    @search = Search.new
  end

  def test

  end

end
