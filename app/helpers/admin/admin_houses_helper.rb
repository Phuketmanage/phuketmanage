module Admin::AdminHousesHelper
  def link_to_google_map(address, google_map)
    return "-" if address.blank?

    if google_map.present?
      link_to address, google_map, target: :blank
    else
      address
    end
  end
end
