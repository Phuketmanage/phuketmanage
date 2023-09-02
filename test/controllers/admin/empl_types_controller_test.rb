require 'test_helper'

class Admin::EmplTypesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @empl_type = empl_types(:one)
  end

  test "should get index" do
    get empl_types_url
    assert_response :success
  end

  test "should get new" do
    get new_empl_type_url
    assert_response :success
  end

  test "should create empl_type" do
    assert_difference('EmplType.count') do
      post empl_types_url, params: { empl_type: { name: @empl_type.name } }
    end

    assert_redirected_to empl_type_url(EmplType.last)
  end

  test "should show empl_type" do
    get empl_type_url(@empl_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_empl_type_url(@empl_type)
    assert_response :success
  end

  test "should update empl_type" do
    patch empl_type_url(@empl_type), params: { empl_type: { name: @empl_type.name } }
    assert_redirected_to empl_type_url(@empl_type)
  end

  test "should destroy empl_type" do
    assert_difference('EmplType.count', -1) do
      delete empl_type_url(@empl_type)
    end

    assert_redirected_to empl_types_url
  end
end
