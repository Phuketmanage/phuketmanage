require 'test_helper'

class PricesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @price = prices(:_1)
  end

  test "should get index" do
    get house_prices_url(@price.house.number)
    assert_response :success
  end
end
