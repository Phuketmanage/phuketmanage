class SearchController < ApplicationController
  def index
    @search = Search.new(search_params)
    if @search.stage == nil || @search.stage == '1'
      @houses = []
      if !@search.valid?
        render :index and return
      end
      @search.prepare @settings
      @houses = @search.get_available_houses
      @prices = @search.get_prices @houses
    end
  end

  private
    def search_params
       params.require(:search).permit(:stage, :rs, :rf)
    end

end
