class PagesController < ApplicationController
  # authorize_resource :class => false

  layout 'test', only: :test

  def index
    @search = Search.new
  end

  def about

  end


  def test

  end

end
