require 'rails_helper'

RSpec.describe ExchangeRateJob, type: :job do

  describe '#perform' do
    it 'calls Setting.get_usd_rate' do
      expect(Setting).to receive(:sync_usd_rate)
      subject.perform
    end
  end

  describe '#retry_on' do
    it 'retries on StandardError' do
      allow(subject).to receive(:perform).and_raise(StandardError)
      expect(subject).to receive(:retry_job)
      subject.perform_now
    end

    describe '.send_email_to_admin' do
      it 'sends an email to the admin' do
        error = 'Something went wrong'
        expect(AdminMailer).to receive(:notify_failure).with(error).and_return(double(deliver_now: true))
        described_class.send(:send_email_to_admin, error)
      end
    end
  end
end
