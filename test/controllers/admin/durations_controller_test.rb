require 'test_helper'

class Admin::DurationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @duration = durations(:_1)
  end

  test "should destroy duration" do
    house = @duration.house
    assert_difference('Duration.count', -1) do
      delete admin_house_delete_duration_path(house.id, duration_id: @duration.id)
    end

    assert_redirected_to admin_house_prices_path(house.id)
  end
end
