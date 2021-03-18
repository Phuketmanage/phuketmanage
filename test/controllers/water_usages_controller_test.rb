require 'test_helper'

class WaterUsagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @water_usage = water_usages(:one)
  end

  test "should get index" do
    get water_usages_url
    assert_response :success
  end

  # test "should get new" do
  #   get new_water_usage_url
  #   assert_response :success
  # end

  test "should create water_usage" do
    assert_difference('WaterUsage.count') do
      post water_usages_url, params: { water_usage: { amount: @water_usage.amount, date: Date.today , house_id: @water_usage.house_id } }
    end
  end

  # test "should show water_usage" do
  #   get water_usage_url(@water_usage)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_water_usage_url(@water_usage)
  #   assert_response :success
  # end

  test "should update water_usage" do
    patch water_usage_url(@water_usage), params: { water_usage: { amount: @water_usage.amount, date: @water_usage.date, house_id: @water_usage.house_id } }
    assert_redirected_to water_usages_url(house_id: @water_usage.house_id)
  end

  test "should destroy water_usage" do
    assert_difference('WaterUsage.count', -1) do
      delete water_usage_url(@water_usage)
    end

    assert_redirected_to water_usages_url
  end
end
