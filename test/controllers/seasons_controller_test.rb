require 'test_helper'

class SeasonsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @season = seasons(:_1)
  end

  test "should destroy season" do
    house = @season.house
    assert_difference('Season.count', -1) do
      delete admin_house_delete_season_path(house.id, season_id: @season.id)
    end

    assert_redirected_to admin_house_prices_path(house.id)
  end
end
