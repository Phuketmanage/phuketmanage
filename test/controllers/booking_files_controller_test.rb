require 'test_helper'

class BookingFilesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get booking_files_create_url
    assert_response :success
  end

  test "should get update" do
    get booking_files_update_url
    assert_response :success
  end

  test "should get delete" do
    get booking_files_delete_url
    assert_response :success
  end

end
