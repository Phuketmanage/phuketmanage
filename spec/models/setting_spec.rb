# == Schema Information
#
# Table name: settings
#
#  id          :bigint           not null, primary key
#  description :string
#  value       :string
#  var         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Setting do
  context 'when call .get_usd_rate' do
    let(:url) { "https://openexchangerates.org/api/latest.json?app_id=#{ENV['EXCHANGE_APP_ID']}" }
    let(:body) { '{ "timestamp": 1695650400, "base": "USD","rates": { "UAH": 34.73005, "THB": 36.123 } }' }
    let!(:thb) { create(:setting, :usd_rate, value: 33) }

    it do
      body1 = '{ "timestamp": 1695650400, "base": "USD","rates": { "TRY": 27.13005, "THB": 36.723 } }'
      stub_request(:get, url).to_return(status: 200, body: body1, headers: { 'Content-Type': 'application/json' })
      expect(described_class.last.value).to eq('33')
      described_class.sync_usd_rate
      expect(described_class.last.value).to eq('36')
    end

    it 'updates usd rate in db' do
      stub_request(:get, url).to_return(status: 200, body: body, headers: { 'Content-Type': 'application/json' })
      described_class.send(:update_usd_rate, 35)
      expect(described_class.last.value).to eq('35')
    end

    it 'returns usd rate' do
      stub_request(:get, url).to_return(status: 200, body: body, headers: { 'Content-Type': 'application/json' })
      expect(described_class.send(:get_usd_rate)).to eq(35)
    end
  end
end
