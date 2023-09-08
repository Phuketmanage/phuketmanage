require 'test_helper'

class Admin::BookingFilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @transaction = transactions(:one)
  end

  test "should destroy booking file" do
    file = booking_files(:one)
    assert_difference('BookingFile.count', -1) do
      delete booking_file_path(id: file.id), xhr: true
    end
  end
end
