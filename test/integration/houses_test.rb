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
      post admin_houses_url params: { house: {
        description_en: "New house",
        description_ru: "Новый дом",
        owner_id: @house.owner_id,
        code: "NH1",
        rooms: 2,
        bathrooms: 1,
        location_ids: [locations(:patong).id],
        type_id: @house.type_id
        # number: (('1'..'9').to_a).shuffle[0..rand(1..6)].join,
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
    assert_redirected_to admin_houses_url
    follow_redirect!
    assert_select 'div.alert li', text: "House NH1 was successfully created."
    assert_equal("Villa 2 BDR Patong", new_house.generated_title(:en))
    assert_equal("Вилла 2 СП Патонг", new_house.generated_title(:ru))
    sign_out(:admin)
  end

  test "should show proper titles" do
    get root_path
    assert_response :success
    assert_match "Villa 3 BDR Phuket", response.body
    get guests_locale_root_path( locale: :ru)
    assert_response :success
    assert_match "Вилла 3 СП Пхукет", response.body
  end

  test "should show beds when exist" do
    sign_in users(:admin)
    assert_difference('House.count') do
      post admin_houses_url params: { house: {
        description_en: "New house",
        description_ru: "Новый дом",
        owner_id: @house.owner_id,
        code: "MH2",
        rooms: 2,
        bathrooms: 1,
        kingBed: 2,
        location_ids: [locations(:patong).id],
        type_id: @house.type_id
      } }
    end
    follow_redirect!
    sign_out users(:admin)
    get guests_house_path(id: House.first.number)
    assert_response :success
    assert_no_match "Sleeping arrangements", response.body
    get guests_house_path(id: House.last.number)
    assert_response :success
    assert_match "Sleeping arrangements", response.body
  end

  test 'minimal duration for selected house search' do
    # The duration period is less than house min booking period
    year = Date.current.year + 1
    rs = "22.07.#{year}".to_date
    rf = "27.07.#{year}".to_date
    period = "#{rs} to #{rf}"
    house = houses(:villa_1)

    get guests_house_path(id: house.number, params: { period:, commit: "Check price" })
    assert_select 'div.alert li',
                  text: 'This house minimum rental period is 6 nights. Please modify your rental period to increase it.'
    # ru
    get guests_house_path(id: house.number, locale: :ru, params: { period:, commit: "Check price" })
    assert_select 'div.alert li',
                  text: 'Минимальный срок аренды для выбранного объекта 6 ночей. Пожалуйста выберете другие даты чтобы увеличить срок аренды.'

    # If duration is ok - no error messages
    rs = "22.07.#{year}".to_date
    rf = "28.07.#{year}".to_date
    period = "#{rs} to #{rf}"

    get guests_house_path(id: house.number, locale: nil, params: { period:, commit: "Check price" })
    assert_select 'div.alert li', count: 0
  end
end
