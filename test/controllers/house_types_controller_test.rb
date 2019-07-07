require 'test_helper'

class HouseTypesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @house_type = house_types(:villa)
  end

  test "should get index" do
    get house_types_url
    assert_response :success
  end

  test "should get new" do
    get new_house_type_url
    assert_response :success
  end

  test "should create house_type" do
    assert_difference('HouseType.count') do
      post house_types_url, params: { house_type: { name_en: @house_type.name_en, name_ru: @house_type.name_ru } }
    end

    assert_redirected_to house_type_url(HouseType.last)
  end

  test "should show house_type" do
    get house_type_url(@house_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_house_type_url(@house_type)
    assert_response :success
  end

  test "should update house_type" do
    patch house_type_url(@house_type), params: { house_type: { name_en: @house_type.name_en, name_ru: @house_type.name_ru } }
    assert_redirected_to house_type_url(@house_type)
  end

  test "should destroy house_type" do
    sign_in users(:admin)
    House.destroy_all
    assert_difference('HouseType.count', -1) do
      delete house_type_url(@house_type)
    end

    assert_redirected_to house_types_url
  end
end
