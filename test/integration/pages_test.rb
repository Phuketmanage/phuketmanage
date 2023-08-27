require 'test_helper'

class PagesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should show dashboard link" do
    get root_path
    assert_response :success
    assert_no_match "Admin dashboard", response.body
    sign_in users(:admin)
    get root_path
    assert_response :success
    assert_match "Admin dashboard", response.body
    sign_out users(:admin)
    sign_in users(:manager)
    get root_path
    assert_response :success
    assert_match "Admin dashboard", response.body
    sign_out users(:manager)
    sign_in users(:accounting)
    get root_path
    assert_response :success
    assert_match "Admin dashboard", response.body
    sign_out users(:accounting)
    sign_in users(:owner)
    get root_path
    assert_response :success
    assert_match "Admin dashboard", response.body
    sign_out users(:owner)
  end
end
