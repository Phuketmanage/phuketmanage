class AdminMailer < ApplicationMailer
  def notify_failure(exception)
    @exception_message = exception.message
    mail(to: 'info@phuketmanage.com ', subject: 'Task execution error')
  end
end
