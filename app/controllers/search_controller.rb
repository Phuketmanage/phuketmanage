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
      rs_e = @search.rs - @settings['dtnb'].to_i.days
      rf_e = @search.rf + @settings['dtnb'].to_i.days
      @houses = booking.get_available_houses rs_e, rf_e
      @prices = @search.get_prices @houses
    end
  end

  private
    def search_params
       params.require(:search).permit(:stage, :rs, :rf)
    end

end
