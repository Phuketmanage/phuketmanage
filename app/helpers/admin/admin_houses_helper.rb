module Admin::AdminHousesHelper
  def link_to_google_map(address, google_map)
    return "-" if address.blank?

    if google_map.present?
      link_to address, google_map, target: :blank
    else
      address
    end
  end

  def generated_link_to_guests_house(house)
    guests_house_url(id: house.number, params: params.permit(:period))
  end
end
