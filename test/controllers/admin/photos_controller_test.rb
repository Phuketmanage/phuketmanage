require 'test_helper'

class Admin::PhotosControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @house = houses(:villa_1)
  end

  test "should get index" do
    get admin_house_photos_path(@house.number)
    assert_response :success
  end
end
