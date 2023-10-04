class ExchangeRateJob < ApplicationJob
  retry_on StandardError, wait: 10.minutes, attempts: 2 do |_job, exception|
    send_email_to_admin exception.message
  end

  def perform
    Setting.sync_usd_rate
  end

  private

  def self.send_email_to_admin(exception)
    AdminMailer.notify_failure(exception).deliver_now
  end
end
