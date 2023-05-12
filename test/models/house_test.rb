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
    assert_not new_house.valid?
    number_unique = false
    until number_unique
      number = ('1'..'9').to_a.shuffle[0..rand(1..6)].join
      house = House.find_by(number: number)
      number_unique = true if house.nil?
    end
    new_house.number = number
    assert new_house.valid? 
  end
end
