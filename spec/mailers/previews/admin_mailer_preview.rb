# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def notify_failure
    exception = 'Failed to fetch exchange rate data'
    AdminMailer.notify_failure(exception)
  end
end
