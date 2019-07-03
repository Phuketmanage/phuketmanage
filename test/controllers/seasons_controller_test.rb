require 'test_helper'

class SeasonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @season = seasons(:_1)
  end

  test "should get index" do
    get house_seasons_path(@season.house)
    assert_response :success
  end

  test "should get new" do
    get new_house_season_url(@season.house)
    assert_response :success
  end

  test "should create season" do
    assert_difference('Season.count') do
      post house_seasons_url(@season.house), params: { season: { sfd: @season.sfd, sfm: @season.sfm, ssd: @season.ssd, ssm: @season.ssm } }
    end

    assert_redirected_to house_seasons_path(Season.last.house)
  end

  test "should get edit" do
    get edit_season_url(@season)
    assert_response :success
  end

  test "should update season" do
    patch season_url(@season), params: { season: { house_id: @season.house_id, sfd: @season.sfd, sfm: @season.sfm, ssd: @season.ssd, ssm: @season.ssm } }
    assert_redirected_to house_seasons_path(@season.house)
  end

  test "should destroy season" do
    house = @season.house
    assert_difference('Season.count', -1) do
      delete season_url(@season)
    end

    assert_redirected_to house_seasons_url(house)
  end
end
