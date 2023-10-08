class AdminMailer < ApplicationMailer
  def notify_failure(exception, subject)
    @exception = exception
    mail(to: 'info@phuketmanage.com ', subject: )
  end
end
