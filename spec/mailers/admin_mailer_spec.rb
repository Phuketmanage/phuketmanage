require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  context "when send exception to admin" do
    let(:mail_text) { 'Failed to fetch exchange rate data' }
    let(:mail) { described_class.notify_failure(mail_text, 'Error').deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Error')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(['info@phuketmanage.com'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@phuketmanage.com'])
    end

    it 'renders the text email' do
      expect(mail.body.encoded).to have_text(mail_text)
    end
  end
end
