EXCHANGE_SERVER_URL = 'https://openexchangerates.org/api/latest.json'
EXCHANGE_APP_ID     = ENV.fetch('EXCHANGE_APP_ID', nil)

if ARGV.include?('start')
  Rails.application.config.after_initialize do
    if EXCHANGE_APP_ID.nil?
      Notification.create(level: 'Error', text: 'APP_ID is not set for exchange rate script')
      exception = 'APP_ID is not set for exchange rate script'
      subject   = 'Exchange error'
      AdminMailer.notify_failure(exception, subject).deliver_now
    end
  end
end
