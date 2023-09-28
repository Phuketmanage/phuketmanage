require 'test_helper'

class TiemelineTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:manager)
  end

  test 'should show correct houses' do
    get timeline_bookings_path
    assert_response :success
    # assert_match 'Hidden comment', response.body
    assert_select "div.house_code", 7

    # Should not show houses where hide_in_timeline
    villa = houses(:villa_3)
    villa.update(hide_in_timeline: true)
    get timeline_bookings_path
    assert_response :success
    assert_select "div.house_code", 6
    assert_select "div.house_code[data-house-id=#{villa.id}]", 0

    # Should not show houses where balance_closed
    villa = houses(:villa_6)
    villa.update(balance_closed: true)
    get timeline_bookings_path
    assert_response :success
    assert_select "div.house_code", 5
    assert_select "div.house_code[data-house-id=#{villa.id}]", 0
  end
end
