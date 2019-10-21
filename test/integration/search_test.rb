require 'test_helper'

class SearchTest < ActionDispatch::IntegrationTest
  # include Devise::Test::IntegrationHelpers

  # setup do

  #   # b1 = bookings(:one)
  # end

  test 'available houses' do
    year = Time.now.year+1
    # Start > Finish
    rs = "1.10.#{year}".to_date
    rf = "31.07.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_match 'End of stay can not be less then beginig', response.body
    assert_select 'div.house', count: 0

    # Start or Finish in the past
    rs = "1.10.#{year-2}".to_date
    rf = "31.07.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_match 'Begining or End of period can not be in the past', response.body
    assert_select 'div.house', count: 0
    rs = "1.10.#{year-2}".to_date
    rf = "30.11.#{year-2}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_match 'Begining or End of period can not be in the past', response.body
    assert_select 'div.house', count: 0

    # At least 2 days in advance
    rs = Time.now.in_time_zone('Bangkok').to_date+1.day
    rf = rs+5.days
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_match 'You can book at least 2 days in advance', response.body
    assert_select 'div.house', count: 0

    # Min 5 days
    rs = "1.10.#{year}".to_date
    rf = "5.10.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_match 'Minimum rental period is 5 days', response.body
    assert_select 'div.house', count: 0

    # Available houses
    rs = "01.07.#{year}".to_date
    rf = "08.07.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 7 days'
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
    assert_select 'div.duration', 'Total rental period: 7 days'
    assert_select 'div.house', count: 1
    assert_select 'div.house', 'Villa 2'
    assert_select 'div.price', '26600 THB'

    # True only if days between bookngs set to 2
    rs = "21.07.#{year}".to_date
    rf = "30.07.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 9 days'
    assert_select 'div.house', count: 1
    assert_select 'div.house', 'Villa 2'

    # True only if days between bookngs set to 2
    rs = "21.07.#{year}".to_date
    rf = "31.07.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 10 days'
    assert_select 'div.house', count: 0

    # True only if days between bookngs set to 2
    rs = "22.07.#{year}".to_date
    rf = "31.07.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 9 days'
    assert_select 'div.house', count: 1
    assert_select 'div.house', 'Villa 1'

    rs = "20.07.#{year}".to_date
    rf = "25.07.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 5 days'
    assert_select 'div.house', count: 1
    assert_select 'div.house', 'Villa 2'

    # Price calculations
    rs = "15.11.#{year}".to_date
    rf = "25.11.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 10 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '40000 THB'
    assert_select 'div.house', 'Villa 2'
    assert_select 'div.price', '54000 THB'
    assert_select 'div.house', 'Villa 3'
    assert_select 'div.price', '94000 THB'

    rs = "15.11.#{year}".to_date
    rf = "1.12.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 16 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '54400 THB'

    rs = "15.11.#{year}".to_date
    rf = "5.12.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 20 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '79900 THB'

    rs = "1.11.#{year}".to_date
    rf = "5.12.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 34 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '105000 THB'

    rs = "15.11.#{year}".to_date
    rf = "15.12.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 30 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '118300 THB'

    rs = "15.11.#{year}".to_date
    rf = "25.12.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 40 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '188300 THB'

    rs = "10.12.#{year}".to_date
    rf = "25.12.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 15 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '116875 THB'

    rs = "10.12.#{year}".to_date
    rf = "10.01.#{year+1}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 31 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '208250 THB'

    rs = "10.12.#{year}".to_date
    rf = "15.01.#{year+1}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 36 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '243250 THB'

    rs = "10.12.#{year}".to_date
    rf = "25.01.#{year+1}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 46 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '295750 THB'

    # 23.07.2019 catch up
    rs = "5.01.#{year}".to_date
    rf = "22.01.#{year}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 17 days'
    assert_select 'div.house', count: 3
    assert_select 'div.house', 'Villa 1'
    assert_select 'div.price', '129625 THB'

    # 23.07.2019 catch up
    rs = "26.12.#{year}".to_date
    rf = "09.01.#{year+1}".to_date
    get search_path params: { search: { rs: rs, rf: rf } }
    assert_select 'div.duration', 'Total rental period: 14 days'
    # assert_select 'div.house', count: 3
    # assert_select 'div.house', 'Villa 1'
    # assert_select 'div.price', '129625 THB'


  end

end
