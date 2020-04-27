require 'test_helper'

class HouseGroupsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @house_group = house_groups(:one)
  end

  test "should get index" do
    get house_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_house_group_url
    assert_response :success
  end

  test "should create house_group" do
    assert_difference('HouseGroup.count') do
      post house_groups_url, params: { house_group: { name: @house_group.name } }
    end

    assert_redirected_to house_group_url(HouseGroup.last)
  end

  test "should show house_group" do
    get house_group_url(@house_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_house_group_url(@house_group)
    assert_response :success
  end

  test "should update house_group" do
    patch house_group_url(@house_group), params: { house_group: { name: @house_group.name } }
    assert_redirected_to house_group_url(@house_group)
  end

  test "should destroy house_group" do
    assert_difference('HouseGroup.count', -1) do
      delete house_group_url(@house_group)
    end

    assert_redirected_to house_groups_url
  end
end
