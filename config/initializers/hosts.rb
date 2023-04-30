if Rails.env.development?
  Rails.application.config.hosts << 'phuketmanage.test'
end
