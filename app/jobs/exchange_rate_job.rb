class ExchangeRateJob < ApplicationJob
  def perform
    Setting.get_usd_rate
  end

  def send_email_to_admin(exception)
    AdminMailer.notify_failure(exception).deliver_now
  end
end
