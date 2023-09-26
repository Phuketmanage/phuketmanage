require 'rails_helper'

RSpec.describe Setting do
  context 'when call .get_usd_rate' do
    it do
      stub_request(:get, "https://openexchangerates.org/api/latest.json?app_id=#{ENV['YOUR_APP_ID']}")
        .to_return(status: 200,
                   body: '{ "disclaimer": "Usage subject to terms: https://openexchangerates.org/terms",
                            "license": "https://openexchangerates.org/license",
                            "timestamp": 1695650400, "base": "USD","rates": { "AED": 3.673005, "THB": 36.123 } }',
                   headers: { 'Content-Type': 'application/json' })
      expect(described_class.get_usd_rate).to be_an_instance_of(Integer)
    end

    it do
      WebMock.allow_net_connect!
      rate = ValueObjects::CurrencyExchangeRate.new
      expect(rate.response_status).to eq(200)
    end
  end
end
