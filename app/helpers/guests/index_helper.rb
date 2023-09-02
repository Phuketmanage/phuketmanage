module Guests::IndexHelper
  def redirected_locale_params
    params.permit(:period, search: [:period, { type: [], bdr: [], location: [] }])
  end
end
