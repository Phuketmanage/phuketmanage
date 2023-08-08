require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do
  let(:user) { create(:user, :owner) }

  describe "Reset password instructions" do
    let(:token) { user.send(:set_reset_password_token) }
    let(:mail) { described_class.reset_password_instructions(user, token).deliver_later }
    let(:recovery_path) { "http://localhost:3000/users/password/edit?reset_password_token=#{token}" }

    it 'renders the subject' do
      expect(mail.subject).to eq('Password reset request')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['info@phuketmanage.com'])
    end

    it 'assigns @confirmation_url' do
      expect(mail.body.encoded)
        .to have_link("Change my password", href: recovery_path)
    end
  end
end
