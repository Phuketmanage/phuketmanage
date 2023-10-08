class AdminMailer < ApplicationMailer
  skip_before_action :set_settings

  def notify_failure(exception, subject)
    @exception = exception
    mail(to: 'info@phuketmanage.com ', subject: subject)
  end
end
