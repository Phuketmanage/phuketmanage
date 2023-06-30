require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  setup do
    @house = houses(:villa_6)
    @house.locations << locations(:phuket)
  end

  test "should save with number" do 
    new_house = House.new(description_en: "New house",
                          description_ru: "Новый дом",
                          owner_id: @house.owner_id,
                          code: "MH1",
                          rooms: 2,
                          bathrooms: 1,
                          location_ids: [locations(:patong).id],
                          type_id: @house.type_id)
    assert new_house.valid?
    new_house.save!
    assert new_house.number != nil
  end
end
