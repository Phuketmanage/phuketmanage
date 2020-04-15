class SearchController < ApplicationController
  def index
    @search = Search.new( rs: params[:search][:rs],
                          rf: params[:search][:rf],
                          dtnb: @settings['dtnb'])
    # redirect_to root_path and return if !@search.valid?

    if @search.stage == nil || @search.stage == '1'
      @houses = []
      if !@search.valid?
        render :index and return
      end
      @houses = @search.get_available_houses
      @prices = @search.get_prices @houses
    end
  end

  private
    def search_params
       params.require(:search).permit(:stage, :rs, :rf)
    end

end
