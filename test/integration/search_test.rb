require 'test_helper'

class SearchTest < ActionDispatch::IntegrationTest
  # include Devise::Test::IntegrationHelpers

  # setup do

  #   # b1 = bookings(:one)
  # end

  test 'available houses' do
    year = Time.zone.now.year + 1
    # Start > Finish
    rs = "1.10.#{year}".to_date
    rf = "31.07.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_match 'End of stay can not be less then beginig', response.body
    assert_select 'div.house', count: 0

    # Start or Finish in the past
    rs = "1.10.#{year - 2}".to_date
    rf = "31.07.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_match 'Begining or End of period can not be in the past', response.body
    assert_select 'div.house', count: 0
    rs = "1.10.#{year - 2}".to_date
    rf = "30.11.#{year - 2}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_match 'Begining or End of period can not be in the past', response.body
    assert_select 'div.house', count: 0

    # At least 2 days in advance
    rs = Time.now.in_time_zone('Bangkok').to_date + 1.day
    rf = rs + 5.days
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_match 'You can book at least 2 days in advance', response.body
    assert_select 'div.house', count: 0

    # Min 5 days
    rs = "1.10.#{year}".to_date
    rf = "5.10.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_match 'Minimum rental period is 5 days', response.body
    assert_select 'div.house', count: 0

    # Available houses
    rs = "01.07.#{year}".to_date
    rf = "08.07.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 7'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿21,000'
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿26,600'
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿44,800'

    rs = "12.07.#{year}".to_date
    rf = "19.07.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 7'
    assert_select 'div.house', count: 1
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿26,600'

    # True only if days between bookngs set to 2
    rs = "21.07.#{year}".to_date
    rf = "30.07.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 9'
    assert_select 'div.house', count: 1
    assert_select 'h5.house_title', 'Villa 3 BDR'

    # True only if days between bookngs set to 2
    rs = "21.07.#{year}".to_date
    rf = "31.07.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'div.house', count: 0

    # True only if days between bookngs set to 2
    rs = "22.07.#{year}".to_date
    rf = "31.07.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 9'
    assert_select 'div.house', count: 1
    assert_select 'h5.house_title', 'Villa 3 BDR'

    rs = "20.07.#{year}".to_date
    rf = "25.07.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 5'
    assert_select 'div.house', count: 1
    assert_select 'h5.house_title', 'Villa 3 BDR'

    # Price calculations
    rs = "15.11.#{year}".to_date
    rf = "25.11.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 3, 'Total nights: 10'
    assert_select 'div.house', 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿40,000'
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿54,000'
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿94,000'

    rs = "15.11.#{year}".to_date
    rf = "1.12.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 16'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿54,400'

    rs = "15.11.#{year}".to_date
    rf = "5.12.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 20'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿79,900'

    rs = "1.11.#{year}".to_date
    rf = "5.12.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 34'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿105,000'

    rs = "15.11.#{year}".to_date
    rf = "15.12.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 30'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿118,300'

    rs = "15.11.#{year}".to_date
    rf = "25.12.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 40'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿188,300'

    rs = "10.12.#{year}".to_date
    rf = "25.12.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 15'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿116,875'

    rs = "10.12.#{year}".to_date
    rf = "10.01.#{year + 1}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 31'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿208,250'

    rs = "10.12.#{year}".to_date
    rf = "15.01.#{year + 1}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 36'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿243,250'

    rs = "10.12.#{year}".to_date
    rf = "25.01.#{year + 1}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 46'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿295,750'

    # 23.07.2019 catch up
    rs = "5.01.#{year}".to_date
    rf = "22.01.#{year}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 17'
    assert_select 'div.house', count: 3
    assert_select 'h5.house_title', 'Villa 3 BDR'
    assert_select 'h5.house_price', '฿129,625'

    # 23.07.2019 catch up
    rs = "26.12.#{year}".to_date
    rf = "09.01.#{year + 1}".to_date
    period = "#{rs} to #{rf}"
    get search_path params: { search: { period: } }
    assert_select 'p.duration', 'Total nights: 14'
    # assert_select 'div.house', count: 3
    # assert_select 'h5.house_title', 'villa_1 Villa 3 BDR'
    # assert_select 'h5.house_price', '129625 THB'
  end
end
