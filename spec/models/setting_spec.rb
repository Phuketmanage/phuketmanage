require 'rails_helper'

RSpec.describe Setting do
  context 'when call .get_usd_rate' do
    let(:url) { "https://openexchangerates.org/api/latest.json?app_id=#{ENV['EXCHANGE_APP_ID']}" }

    before { create(:setting, :usd_rate) }

    it do
      body = '{ "timestamp": 1695650400, "base": "USD","rates": { "TRY": 27.13005, "THB": 36.723 } }'
      stub_request(:get, url).to_return(status: 200, body: body, headers: { 'Content-Type': 'application/json' })
      expect(described_class.get_usd_rate).to eq(36)
    end

    it do
      body = '{ "timestamp": 1695650400, "base": "USD","rates": { "UAH": 34.73005, "THB": 36.123 } }'
      stub_request(:get, url).to_return(status: 200, body: body, headers: { 'Content-Type': 'application/json' })
      described_class.get_usd_rate
      expect(Setting.last.value).to eq('35')
    end
  end
end
