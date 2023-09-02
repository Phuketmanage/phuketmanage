require 'test_helper'

class Admin::BookingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @booking = bookings(:_1)
  end

  test "should get index" do
    get bookings_url
    assert_response :success
  end

  test "should get new" do
    get new_booking_url
    assert_response :success
  end

  test "should show booking" do
    get booking_url(@booking)
    assert_response :success
  end

  test "should get edit" do
    get edit_booking_url(@booking)
    assert_response :success
  end

  test "should create booking" do
    assert_difference('Booking.count', 1) do
      post bookings_path, params: { booking: {
        start: "10.09.#{Date.current.year + 1}".to_date,
        finish: "20.09.#{Date.current.year + 1}".to_date,
        house_id: houses(:villa_1).id,
        status: 'confirmed',
        client_details: 'Test client'
      } }
    end
    booking = Booking.last
    hid = House.find(booking.house_id).number
    assert_redirected_to bookings_path(hid:)
  end

  test "should update booking" do
    patch booking_url(@booking), params: { booking: {
      start: @booking.start,
      finish: @booking.finish,
      house_id: @booking.house_id,
      status: 'confirmed',
      client_details: 'Test client'

    } }

    hid = House.find(@booking.house_id).number
    assert_redirected_to bookings_path(hid:)
  end

  test "should destroy booking" do
    assert_difference('Booking.count', -1) do
      delete booking_url(@booking)
    end

    assert_redirected_to bookings_url
  end
end
