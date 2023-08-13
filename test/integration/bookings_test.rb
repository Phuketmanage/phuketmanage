require 'test_helper'

class BookingsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
    @booking = bookings(:_1)
  end

  test 'create new booking' do
    year = Date.current.year + 1
    # House not available
    start = "7.07.#{year}".to_date
    finish = "14.07.#{year}".to_date
    house = houses(:villa_1)
    assert_no_difference 'Booking.count' do
      post bookings_path params: { booking: { start:,
                                              finish:,
                                              house_id: house.id,
                                              status: 'confirmed',
                                              client_details: 'Test client' } }
    end
    assert_select 'div.alert li',
                  text: "House is not available for this period, overlapped with bookings: [\"#{bookings(:_1).start.to_fs(:date)} - #{bookings(:_1).finish.to_fs(:date)}\"]"

    start = "3.07.#{year}".to_date
    finish = "10.07.#{year}".to_date
    house = houses(:villa_1)
    assert_no_difference 'Booking.count' do
      post bookings_path params: { booking: { start:,
                                              finish:,
                                              house_id: house.id,
                                              status: 'confirmed',
                                              client_details: 'Test client' } }
    end
    assert_select 'div.alert li',
                  text: "House is not available for this period, overlapped with bookings: [\"#{bookings(:_1).start.to_fs(:date)} - #{bookings(:_1).finish.to_fs(:date)}\"]"

    start = "20.07.#{year}".to_date
    finish = "27.07.#{year}".to_date
    house = houses(:villa_1)
    assert_no_difference 'Booking.count' do
      post bookings_path params: { booking: { start:,
                                              finish:,
                                              house_id: house.id,
                                              status: 'confirmed',
                                              client_details: 'Test client' } }
    end
    assert_select 'div.alert li',
                  text: "House is not available for this period, overlapped with bookings: [\"#{bookings(:_1).start.to_fs(:date)} - #{bookings(:_1).finish.to_fs(:date)}\"]"

    # House not available have confirmed booking
    start = "20.07.#{year}".to_date
    finish = "28.07.#{year}".to_date
    house = houses(:villa_1)
    assert_no_difference 'Booking.count' do
      post bookings_path params: { booking: { start:,
                                              finish:,
                                              house_id: house.id,
                                              status: 'confirmed',
                                              client_details: 'Test client' } }
    end
    assert_select 'div.alert li',
                  text: "House is not available for this period, overlapped with bookings: [\"#{bookings(:_1).start.to_fs(:date)} - #{bookings(:_1).finish.to_fs(:date)}\"]"

    # House not available have temporary booking
    start = "26.07.#{year}".to_date
    finish = "05.08.#{year}".to_date
    house = houses(:villa_1)
    assert_no_difference 'Booking.count' do
      post bookings_path params: { booking: { start:,
                                              finish:,
                                              house_id: house.id,
                                              status: 'confirmed',
                                              client_details: 'Test client' } }
    end
    assert_select 'div.alert li',
                  text: "House is not available for this period, overlapped with bookings: [\"#{bookings(:_6).start.to_fs(:date)} - #{bookings(:_6).finish.to_fs(:date)}\"]"

    # House not available have block booking
    start = "27.07.#{year}".to_date
    finish = "10.08.#{year}".to_date
    house = houses(:villa_3)
    assert_no_difference 'Booking.count' do
      post bookings_path params: { booking: { start:,
                                              finish:,
                                              house_id: house.id,
                                              status: 'confirmed',
                                              client_details: 'Test client' } }
    end
    assert_select 'div.alert li',
                  text: "House is not available for this period, overlapped with bookings: [\"#{bookings(:_7).start.to_fs(:date)} - #{bookings(:_7).finish.to_fs(:date)}\"]"

    # Can create new booking
    start = "22.07.#{year}"
    finish = "29.07.#{year}"
    house = houses(:villa_1)
    assert_difference 'Booking.count', 1 do
      post bookings_path params: { booking: { start:,
                                              finish:,
                                              house_id: house.id,
                                              status: 'confirmed',
                                              client_details: 'Test client' } }
    end
    hid = House.find(Booking.last.house_id).number
    assert_redirected_to bookings_path(hid:)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully created.'

    # Manager can create new booking even if dtnb = 2
    start = "1.07.#{year}"
    finish = "9.07.#{year}"
    house = houses(:villa_1)
    assert_difference 'Booking.count', 1 do
      post bookings_path params: { booking: { start:,
                                              finish:,
                                              house_id: house.id,
                                              status: 'confirmed',
                                              client_details: 'Test client' } }
    end
    hid = House.find(Booking.last.house_id).number
    assert_redirected_to bookings_path(hid:)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully created.'
  end

  test 'Guest search and create booking' do
    year = Date.current.year + 1
    rs = "15.11.#{year}".to_date
    rf = "25.11.#{year}".to_date
    period = "#{rs} to #{rf}"
    get guests_houses_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 10'
    # assert_match 'Comment for all', response.body
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿40,000'
  end

  test 'update booking' do
    year = Date.current.year + 1
    # Change only dates - house not available
    new_start = "29.06.#{year}".to_date
    put booking_path(@booking.id), params: { booking: { start: new_start,
                                                        finish: @booking.finish,
                                                        house_id: @booking.house.id,
                                                        status: 'confirmed',
                                                        client_details: 'Test client' } }
    assert_select 'div.alert li',
                  text: "House is not available for this period, overlapped with bookings: [\"#{bookings(:_4).start.to_fs(:date)} - #{bookings(:_4).finish.to_fs(:date)}\"]"

    # Change only dates - house available for manager even dtnb = 2
    new_start = "30.06.#{year}".to_date
    put booking_path(@booking.id), params: { booking: { start: new_start,
                                                        finish: @booking.finish,
                                                        house_id: @booking.house.id,
                                                        status: 'confirmed',
                                                        client_details: 'Test client' } }
    hid = House.find(@booking.house.id).number
    assert_redirected_to bookings_path(hid:)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully updated.'

    # Change only dates - house available = success
    new_start = "2.07.#{year}".to_date
    houses(:villa_1)
    put booking_path(@booking.id), params: { booking: { start: new_start,
                                                        finish: @booking.finish,
                                                        house_id: @booking.house.id,
                                                        status: 'confirmed',
                                                        client_details: 'Test client' } }
    hid = House.find(@booking.house.id).number
    assert_redirected_to bookings_path(hid:)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully updated.'
    assert_equal @booking.reload.start, new_start

    # Change only house - house is not available
    old_house = @booking.house
    new_house = houses(:villa_3)
    put booking_path(@booking.id), params: { booking: { start: @booking.start,
                                                        finish: @booking.finish,
                                                        house_id: new_house.id,
                                                        status: 'confirmed',
                                                        client_details: 'Test client' } }
    assert_select 'div.alert li',
                  text: "House is not available for this period, overlapped with bookings: [\"#{bookings(:_2).start.to_fs(:date)} - #{bookings(:_2).finish.to_fs(:date)}\"]"
    assert_equal @booking.reload.house_id, old_house.id

    # Change only house - house available = success
    new_house = houses(:villa_2)
    put booking_path(@booking.id), params: { booking: { start: @booking.start,
                                                        finish: @booking.finish,
                                                        house_id: new_house.id,
                                                        status: 'confirmed',
                                                        client_details: 'Test client' } }
    hid = House.find(new_house.id).number
    assert_redirected_to bookings_path(hid:)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully updated.'
    assert_equal @booking.reload.house.id, new_house.id

    # Change dates and house - house is not available
    new_start = "7.07.#{year}".to_date
    new_finish = "17.07.#{year}".to_date
    new_house = houses(:villa_3)
    put booking_path(@booking.id), params: { booking: { start: new_start,
                                                        finish: new_finish,
                                                        house_id: new_house.id,
                                                        status: 'confirmed',
                                                        client_details: 'Test client' } }
    assert_select 'div.alert li',
                  text: "House is not available for this period, overlapped with bookings: [\"#{bookings(:_2).start.to_fs(:date)} - #{bookings(:_2).finish.to_fs(:date)}\"]"

    # Change dates and house - house is not available because dtnb = 2
    new_start = "25.07.#{year}".to_date
    new_finish = "2.08.#{year}".to_date
    new_house = houses(:villa_3)
    put booking_path(@booking.id), params: { booking: { start: new_start,
                                                        finish: new_finish,
                                                        house_id: new_house.id,
                                                        status: 'confirmed',
                                                        client_details: 'Test client' } }
    assert_select 'div.alert li',
                  text: "House is not available for this period, overlapped with bookings: [\"#{bookings(:_2).start.to_fs(:date)} - #{bookings(:_2).finish.to_fs(:date)}\"]"

    # Change dates and house - house is available even dtnb = 2
    new_start = "26.07.#{year}".to_date
    new_finish = "2.08.#{year}".to_date
    new_house = houses(:villa_3)
    put booking_path(@booking.id), params: { booking: { start: new_start,
                                                        finish: new_finish,
                                                        house_id: new_house.id,
                                                        status: 'confirmed',
                                                        client_details: 'Test client' } }
    hid = House.find(new_house.id).number
    assert_redirected_to bookings_path(hid:)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully updated.'

    # Change dates and house - house is available = success
    new_start = "22.07.#{year}".to_date
    new_finish = "30.07.#{year}".to_date
    new_house = houses(:villa_2)
    put booking_path(@booking.id), params: { booking: { start: new_start,
                                                        finish: new_finish,
                                                        house_id: new_house.id,
                                                        status: 'confirmed',
                                                        client_details: 'Test client' } }
    hid = House.find(@booking.house.id).number
    assert_redirected_to bookings_path(hid:)
    follow_redirect!
    assert_select 'div.alert li', text: 'Booking was successfully updated.'
    assert_equal @booking.reload.start, new_start
    assert_equal @booking.reload.finish, new_finish
    assert_equal @booking.reload.house.id, new_house.id
  end

  test 'owner at front can see only his amounts' do
    sign_in users(:owner)
    get bookings_front_path
    assert_response :success
    assert_select 'td', text: '100,000', count: 0 # Sale
    assert_select 'td', text: '20,000', count: 0 # Comm
    assert_select 'td', text: '80,000', count: 1 # Nett

    # Owner can see only confirmed and block but not canceled
    assert_select 'tr.booking_row', count: 5
    assert_select 'tr[data-booking-no=number_1]', count: 1
    assert_select 'tr[data-booking-no=number_2]', count: 1
    assert_select 'tr[data-booking-no=number_3]', count: 1
    assert_select 'tr[data-booking-no=number_4]', count: 1
    assert_select 'tr[data-booking-no=number_7]', count: 1

    sign_in users(:manager)
    get bookings_path
    assert_response :success
    assert_select 'td', text: '100,000.00', count: 1 # Sale
    assert_select 'tr#number_1 td.comm', text: '20,000.00 (20.0%)', count: 1 # Comm
    assert_select 'td', text: '80,000.00', count: 1 # Nett
  end

  test 'owner at front can see only regular comments' do
    sign_in users(:owner)
    get bookings_front_path

    # Owner can not see comment inner
    assert_match 'Comment for all', response.body
    assert_no_match 'Inner comment', response.body
    assert_no_match 'Comment for GR', response.body
  end
end
