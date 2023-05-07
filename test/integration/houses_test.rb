require 'test_helper'

class HousesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @house = houses(:villa_6)
  end
  test "should generate name on method call" do
    sign_in users(:admin)
    assert_difference('House.count') do
      post houses_url params: { house: {
        description_en: @house.description_en,
        description_ru: @house.description_ru,
        owner_id: @house.owner_id,
        code:  @house.code,
        number: @house.number,
        type_id: @house.type_id,
        size: @house.size,
        plot_size: @house.plot_size,
        rooms: @house.rooms,
        bathrooms: @house.bathrooms,
        pool: @house.pool,
        pool_size: @house.pool_size,
        communal_pool: @house.communal_pool,
        parking: @house.parking,
        parking_size: @house.parking_size,
        unavailable: @house.unavailable
      }}
    end
    hid = House.last
    assert_redirected_to houses_url
    follow_redirect!
    assert_select 'div.alert li', text: "House #{@house.code} was successfully created."
    assert_equal hid.generated_title(:en), "villa_6 Villa 3 BDR 3 BTH"
    assert_equal hid.generated_title(:ru), "villa_6 Вилла 3 СП 3 ВН"
    sign_out(:admin)
  end

  test "should show proper title names" do
    get root_path
    assert_response :success
    assert_select "h5.house_title", "villa_6 Villa 3 BDR 3 BTH"
    assert_select "h5.house_title", "villa_7 Villa 3 BDR 3 BTH"
    get root_path params: {search: {test:1}, locale: 'ru'}
    assert_response :success
    assert_select "h5.house_title", "villa_6 Вилла 3 СП 3 ВН"
    assert_select "h5.house_title", "villa_7 Вилла 3 СП 3 ВН"
  end
end
