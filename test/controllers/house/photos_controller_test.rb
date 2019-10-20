require 'test_helper'

class House::PhotosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get house_photos_index_url
    assert_response :success
  end

end
