require 'test_helper'

class PricesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @price = prices(:_1)
  end

  test "should get index" do
    get house_prices_url (@price.house)
    assert_response :success
  end

  test "should get new" do
    get new_house_price_url(@price.house)
    assert_response :success
  end

  test "should create price" do
    assert_difference('Price.count') do
      post house_prices_url(@price.house, ), params: { price: { amount: @price.amount, duration_id: @price.duration_id, season_id: @price.season_id } }
    end

    assert_redirected_to house_prices_url(Price.last.house)
  end

  test "should get edit" do
    get edit_price_url(@price)
    assert_response :success
  end

  test "should update price" do
    patch price_url(@price), params: { price: { amount: @price.amount, duration_id: @price.duration_id, house_id: @price.house_id, season_id: @price.season_id } }
    assert_redirected_to house_prices_url(@price.house)
  end

  test "should destroy price" do
    house = @price.house
    assert_difference('Price.count', -1) do
      delete price_url(@price)
    end

    assert_redirected_to house_prices_url(house)
  end
end
