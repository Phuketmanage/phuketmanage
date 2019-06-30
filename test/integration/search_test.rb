require 'test_helper'

class SearchTest < ActionDispatch::IntegrationTest

  # setup do
  #   b1 = bookings(:one)
  # end

  test 'available houses' do
    year = Time.now.year+1
    rs = "01.07.#{year}".to_date
    rf = "08.07.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '21000 THB'
    assert_select 'div.house', 'Villa 2'
    assert_select 'div.price', '26600 THB'
    assert_select 'div.house', 'Villa 3'
    assert_select 'div.price', '44800 THB'
    rs = "12.07.#{year}".to_date
    rf = "19.07.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.house', count: 1
    assert_select 'div.house', 'Villa 2'
    assert_select 'div.price', '26600 THB'

  end
end
