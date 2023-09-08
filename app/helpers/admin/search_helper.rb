module Admin::SearchHelper
  def generated_link_to_guests_search
    guests_houses_url(params.permit(search: [:period, { type: [], bdr: [], location: [] }]))
  end
end
