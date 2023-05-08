# frozen_string_literal: true

require 'test_helper'

class HousesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @house = houses(:villa_6)
    @house.locations << locations(:phuket)
  end

  test "should generate name on method call" do
    sign_in users(:admin)
    assert_difference('House.count') do
      post houses_url params: { house: {
        description_en: "New house",
        description_ru: "Новый дом",
        owner_id: @house.owner_id,
        code: "CODE",
        rooms: 2,
        bathrooms: 1,
        location_ids: [locations(:patong).id],
        type_id: @house.type_id
        # number: 4,
        # size: @house.size,
        # plot_size: @house.plot_size,
        # pool: @house.pool,
        # pool_size: @house.pool_size,
        # communal_pool: @house.communal_pool,
        # parking: @house.parking,
        # parking_size: @house.parking_size,
        # unavailable: @house.unavailable,
      } }
    end
    new_house = House.last
    assert_redirected_to houses_url
    follow_redirect!
    assert_select 'div.alert li', text: "House CODE was successfully created."
    assert_equal new_house.generated_title(:en), "CODE Villa 2 BDR 1 BTH Patong"
    assert_equal new_house.generated_title(:ru), "CODE Вилла 2 СП 1 ВН Патонг"
    sign_out(:admin)
  end

  test "should show proper titles" do
    get root_path
    assert_response :success
    assert_match "villa_6 Villa 3 BDR 3 BTH Phuket", response.body
    get root_path, params: { locale: 'ru' }
    assert_response :success
    assert_match "villa_6 Вилла 3 СП 3 ВН Пхукет", response.body
  end
end
