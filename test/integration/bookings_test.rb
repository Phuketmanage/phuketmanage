require 'test_helper'

class BookingsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @booking = bookings(:_1)
  end

  test 'create new booking' do
    year = Time.now.year+1
    # House not available
    start = "7.07.#{year}".to_date
    finish = "14.07.#{year}".to_date
    house = houses(:villa_1)
    assert_no_difference 'Booking.count' do
      post bookings_path params: { booking: { start: start,
                                              finish: finish,
                                              house_id: house.id} }
    end
    assert_select 'div.alert li', text: 'House is not available for this period, overlapped with bookings: ["number_1"]'

    start = "3.07.#{year}".to_date
    finish = "10.07.#{year}".to_date
    house = houses(:villa_1)
    assert_no_difference 'Booking.count' do
      post bookings_path params: { booking: { start: start,
                                              finish: finish,
                                              house_id: house.id} }
    end
    assert_select 'div.alert li', text: 'House is not available for this period, overlapped with bookings: ["number_1"]'

    start = "20.07.#{year}".to_date
    finish = "27.07.#{year}".to_date
    house = houses(:villa_1)
    assert_no_difference 'Booking.count' do
      post bookings_path params: { booking: { start: start,
                                              finish: finish,
                                              house_id: house.id} }
    end
    assert_select 'div.alert li', text: 'House is not available for this period, overlapped with bookings: ["number_1"]'

    # Not available if dtnb = 2
    start = "21.07.#{year}".to_date
    finish = "28.07.#{year}".to_date
    house = houses(:villa_1)
    assert_no_difference 'Booking.count' do
      post bookings_path params: { booking: { start: start,
                                              finish: finish,
                                              house_id: house.id} }
    end
    assert_select 'div.alert li', text: 'House is not available for this period, overlapped with bookings: ["number_1"]'

    # Can create new booking
    start = "22.07.#{year}"
    finish = "29.07.#{year}"
    house = houses(:villa_1)
    assert_difference 'Booking.count', 1 do
      post bookings_path params: { booking: { start: start,
                                              finish: finish,
                                              house_id: house.id} }
    end
    assert_redirected_to edit_booking_path(Booking.last)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully created.'


  end

  test 'update booking' do
    year = Time.now.year+1
    # Change only dates - house not available
    new_start = "30.06.#{year}".to_date
    put booking_path(@booking.id), params: {  booking: { start: new_start,
                                              finish: @booking.finish,
                                              house_id: @booking.house.id } }
    assert_select 'div.alert li', text: 'House is not available for this period, overlapped with bookings: ["number_4"]'

    year = Time.now.year+1

    # Change only dates - house not available because dtnb = 2
    new_start = "30.06.#{year}".to_date
    put booking_path(@booking.id), params: {  booking: { start: new_start,
                                              finish: @booking.finish,
                                              house_id: @booking.house.id } }
    assert_select 'div.alert li', text: 'House is not available for this period, overlapped with bookings: ["number_4"]'

    # Change only dates - house available = success
    new_start = "2.07.#{year}".to_date
    house = houses(:villa_1)
    put booking_path(@booking.id), params: {  booking: { start: new_start,
                                              finish: @booking.finish,
                                              house_id: @booking.house.id } }
    assert_redirected_to edit_booking_path(@booking)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully updated.'
    assert_equal @booking.reload.start, new_start

    # Change only house - house is not available
    old_house = @booking.house
    new_house = houses(:villa_3)
    put booking_path(@booking.id), params: {  booking: { start: @booking.start,
                                              finish: @booking.finish,
                                              house_id: new_house.id } }
    assert_select 'div.alert li', text: 'House is not available for this period, overlapped with bookings: ["number_2"]'
    assert_equal @booking.reload.house_id, old_house.id

    # Change only house - house available = success
    new_house = houses(:villa_2)
    put booking_path(@booking.id), params: {  booking: { start: @booking.start,
                                              finish: @booking.finish,
                                              house_id: new_house.id } }
    assert_redirected_to edit_booking_path(@booking)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully updated.'
    assert_equal @booking.reload.house.id, new_house.id

    # Change dates and house - house is not available
    new_start = "7.07.#{year}".to_date
    new_finish = "17.07.#{year}".to_date
    new_house = houses(:villa_3)
    put booking_path(@booking.id), params: {  booking: { start: new_start,
                                              finish: new_finish,
                                              house_id: new_house.id } }
    assert_select 'div.alert li', text: 'House is not available for this period, overlapped with bookings: ["number_2"]'

    # Change dates and house - house is not available because dtnb = 2
    new_start = "26.07.#{year}".to_date
    new_finish = "2.08.#{year}".to_date
    new_house = houses(:villa_3)
    put booking_path(@booking.id), params: {  booking: { start: new_start,
                                              finish: new_finish,
                                              house_id: new_house.id } }
    assert_select 'div.alert li', text: 'House is not available for this period, overlapped with bookings: ["number_2"]'


    # Change dates and house - house is available = success
    new_start = "22.07.#{year}".to_date
    new_finish = "30.07.#{year}".to_date
    new_house = houses(:villa_2)
    put booking_path(@booking.id), params: {  booking: { start: new_start,
                                              finish: new_finish,
                                              house_id: new_house.id } }
    assert_redirected_to edit_booking_path(@booking)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully updated.'
    assert_equal @booking.reload.start, new_start
    assert_equal @booking.reload.finish, new_finish
    assert_equal @booking.reload.house.id, new_house.id


  end


end
