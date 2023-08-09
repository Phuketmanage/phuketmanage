Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.log_formatter = NewRelic::Agent::Logging::DecoratingFormatter.new

  config.lograge.custom_options = lambda do |event|
    {
      host: event.payload[:host],

      process_id: Process.pid,
      request_id: event.payload[:headers]['action_dispatch.request_id'],
      request_time: Time.current,

      remote_ip: event.payload[:remote_ip],
      ip: event.payload[:ip],
      x_forwarded_for: event.payload[:x_forwarded_for]
    }.compact
  end

  config.lograge.custom_payload do |controller|
    {
      user_id: controller.current_user.try(:id)
    }
  end
end
