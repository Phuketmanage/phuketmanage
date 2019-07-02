class SearchController < ApplicationController
  def index
    @search = Search.new(search_params)
    if @search.stage == nil || @search.stage == '1'
      # byebug
      @houses = []
      if !@search.valid?
        render :index and return
      end
      booking = Booking.new
      @houses = booking.get_available_houses @search.rs, @search.rf
      # byebug
      @prices = @search.get_prices @houses
    end
  end

  private
    def search_params
       params.require(:search).permit(:stage, :rs, :rf)
    end

end
