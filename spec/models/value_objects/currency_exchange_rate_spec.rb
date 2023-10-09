require 'rails_helper'
require 'faraday'

RSpec.describe ValueObjects::CurrencyExchangeRate do

  context 'when without token and url' do
    it { expect(EXCHANGE_SERVER_URL).to be_a(String) }
    it { expect(EXCHANGE_APP_ID).to be_a(String) }
  end

  describe '#get_rate' do
    let(:url) { "#{EXCHANGE_SERVER_URL}?app_id=#{ENV['EXCHANGE_APP_ID']}" }

    it 'returns the exchange rate for THB' do
      body = '{ "timestamp": 1695650400, "base": "USD","rates": { "TRY": 27.13005, "THB": 36.723 } }'
      stub_request(:get, url).to_return(status: 200, body: body, headers: { 'Content-Type': 'application/json' })
      expect(subject.get_rate).to be_a(Float)
    end

    it 'raises an error if the response is not successful' do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(double(success?: false))
      expect { subject.get_rate }.to raise_error(StandardError, "Failed to fetch exchange rate data")
    end
  end
end
