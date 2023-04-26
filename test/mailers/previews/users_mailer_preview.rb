# Preview all emails at http://localhost:3000/rails/mailers/transfers_mailer
class UsersMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/transfers_mailer/created
  def reset_password_instructions
    UsersMailer.reset_password_instructions(User.first, "faketoken", {})
  end
end
