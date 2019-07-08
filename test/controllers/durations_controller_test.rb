require 'test_helper'

class DurationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @duration = durations(:_1)
  end

  test "should destroy duration" do
    house = @duration.house
    assert_difference('Duration.count', -1) do
      delete delete_duration_path(house.number, duration_id: @duration.id)
    end

    assert_redirected_to house_prices_path(house.number)
  end
end
