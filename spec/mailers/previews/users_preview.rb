# Preview all emails at http://localhost:3000/rails/mailers/users
class UsersPreview < ActionMailer::Preview
  def reset_password_instructions
    user = FactoryBot.create(:user, :owner)
    user.update(locale: params[:locale])
    token = user.send(:set_reset_password_token)
    UsersMailer.reset_password_instructions(user, token)
  end
end
