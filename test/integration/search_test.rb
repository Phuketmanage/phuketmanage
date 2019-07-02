require 'test_helper'

class SearchTest < ActionDispatch::IntegrationTest

  # setup do
  #   b1 = bookings(:one)
  # end

  test 'available houses' do
    year = Time.now.year+1
    # rs = "01.07.#{year}".to_date
    # rf = "08.07.#{year}".to_date
    # get search_path params: { search: { rs: rs, rf: rf } }
    # assert_select 'div.duration', '7 days'
    # assert_select 'div.house', count: 3
    # assert_select 'div.house', 'Villa 1'
    # assert_select 'div.price', '21000 THB'
    # assert_select 'div.house', 'Villa 2'
    # assert_select 'div.price', '26600 THB'
    # assert_select 'div.house', 'Villa 3'
    # assert_select 'div.price', '44800 THB'

    # rs = "12.07.#{year}".to_date
    # rf = "19.07.#{year}".to_date
    # get search_path params: { search: { rs: rs, rf: rf } }
    # assert_select 'div.duration', '7 days'
    # assert_select 'div.house', count: 1
    # assert_select 'div.house', 'Villa 2'
    # assert_select 'div.price', '26600 THB'

    # # Start > Finish
    # rs = "1.10.#{year}".to_date
    # rf = "31.07.#{year}".to_date
    # get search_path params: { search: { rs: rs, rf: rf } }
    # assert_match 'End of stay can not be less then beginig', response.body

    # # Start or Finish in the past
    # rs = "1.10.#{year-2}".to_date
    # rf = "31.07.#{year}".to_date
    # get search_path params: { search: { rs: rs, rf: rf } }
    # assert_match 'Begining or End of period can not be in the past', response.body
    # rs = "1.10.#{year-2}".to_date
    # rf = "30.11.#{year-2}".to_date
    # get search_path params: { search: { rs: rs, rf: rf } }
    # assert_match 'Begining or End of period can not be in the past', response.body

    # # At least 2 days in advance
    # rs = Time.now.in_time_zone('Bangkok').to_date+1.day
    # rf = rs+5.days
    # get search_path params: { search: { rs: rs, rf: rf } }
    # assert_match 'You can book at least 2 days in advance', response.body

    # # Min 5 days
    # rs = "1.10.#{year}".to_date
    # rf = "5.10.#{year}".to_date
    # get search_path params: { search: { rs: rs, rf: rf } }
    # assert_match 'Minimum rental period is 5 days', response.body

    # Edge of seasons period calculations
    rs = "1.10.#{year}".to_date
    rf = "31.10.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', '30 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '63000 THB'

    rs = "1.10.#{year}".to_date
    rf = "1.11.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', '31 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '65100 THB'


    rs = "1.10.#{year}".to_date
    rf = "2.11.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', '32 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '67900 THB'



  end
end
