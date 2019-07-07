require 'test_helper'

class DurationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @duration = durations(:_1)
  end

  test "should get index" do
    get house_durations_url(@duration.house)
    assert_response :success
  end

  test "should get new" do
    get new_house_duration_url(@duration.house)
    assert_response :success
  end

  test "should create duration" do
    assert_difference('Duration.count') do
      post house_durations_url(@duration.house), params: { duration: { finish: @duration.finish, start: @duration.start } }
    end

    assert_redirected_to house_durations_url(Duration.last.house)
  end

  test "should get edit" do
    get edit_duration_url(@duration)
    assert_response :success
  end

  test "should update duration" do
    patch duration_url(@duration), params: { duration: { finish: @duration.finish, house_id: @duration.house_id, start: @duration.start } }
    assert_redirected_to house_durations_url(@duration.house)
  end

  test "should destroy duration" do
    house = @duration.house
    assert_difference('Duration.count', -1) do
      delete duration_url(@duration)
    end

    assert_redirected_to house_durations_url(house)
  end
end
