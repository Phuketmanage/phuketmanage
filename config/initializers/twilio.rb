Twilio.configure do |config|
  # config.account_sid = Rails.application.secrets.twilio_account_sid
  # config.auth_token = Rails.application.secrets.twilio_auth_token
  config.account_sid = ENV.fetch('TWILIO_ACCOUNT_SID', nil)
  config.auth_token = ENV.fetch('TWILIO_AUTH_TOKEN', nil)
end
