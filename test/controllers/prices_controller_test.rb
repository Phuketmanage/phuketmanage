require 'test_helper'

class PricesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @price = prices(:_1)
  end

  test "should get index" do
    get admin_house_prices_url(@price.house.id)
    assert_response :success
  end
end
