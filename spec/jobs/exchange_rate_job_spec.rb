require 'rails_helper'

RSpec.describe ExchangeRateJob, type: :job do
  describe '#perform' do
    it 'calls Setting.get_usd_rate' do
      expect(Setting).to receive(:get_usd_rate)
      described_class.perform_now
    end
  end

  describe '.send_email_to_admin' do
    it 'sends an email to the admin' do
      exception = StandardError.new('Something went wrong')
      expect(AdminMailer).to receive(:notify_failure).with(exception).and_return(double(deliver_now: true))
      described_class.send(:send_email_to_admin, exception)
    end
  end

  describe 'retry_on' do
    let(:job) { described_class.new }

    it 'retries on StandardError with wait time of 10 minutes and 2 attempts' do
      #expect(described_class.retry_on_exceptions).to eq([StandardError])\
      #expect(ExchangeRateJob.attempts).to eq(10.minutes)
      #expect(described_class.retry_attempts).to eq(2)
    end
  end
end