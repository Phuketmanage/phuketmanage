require 'test_helper'

class HousesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @house = houses(:villa_1)
  end

  test "should get index" do
    get houses_url
    assert_response :success
  end

  test "should get new" do
    get new_house_url
    assert_response :success
  end

  test "should create house" do
    type = house_types(:villa)
    assert_difference('House.count') do
      post houses_url, params: { house: { description_en: @house.description_en, description_ru: @house.description_ru, owner_id: @house.owner_id, title_en: @house.title_en, title_ru: @house.title_ru, type_id: type.id } }
    end

    assert_redirected_to houses_url
  end

  test "should show house" do
    get house_url(@house.number)
    assert_response :success
  end

  test "should get edit" do
    get edit_house_url(@house.number)
    assert_response :success
  end

  test "should update house" do
    patch house_url(@house.number), params: { house: { description_en: @house.description_en, description_ru: @house.description_ru, owner_id: @house.owner_id, title_en: @house.title_en, title_ru: @house.title_ru } }
    assert_redirected_to edit_house_url(@house.number)
  end

  test "should destroy house" do
    sign_in users(:admin)
    assert_difference('House.count', -1) do
      delete house_url(@house.number)
    end

    assert_redirected_to houses_url
  end
end
