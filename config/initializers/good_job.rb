Rails.application.configure do
  config.good_job.execution_mode = :external
  config.good_job.queues = 'default:5'
  config.good_job.enable_cron = true
  config.good_job.smaller_number_is_higher_priority = true

  # Cron jobs
  config.good_job.cron = {
    storage_maintenance: { # each recurring job must have a unique key
      cron: "0 0 * * *", # Every day at 00:00 (Bangkok time) cron-style scheduling format by fugit gem
      class: "ActiveStorageMaintenanceJob", # reference the Job class with a string
      set: { priority: 10 }, # additional ActiveJob properties; can also be a lambda/proc e.g. `-> { { priority: [1,2].sample } }`
      description: "Purges unattached Active Storage blobs." # optional description that appears in Dashboard
    },
    exchange_maintenance: {
      cron: "5 0 * * *",
      class: "ExchangeRateJob",
      set: { priority: 10 },
      description: "Updates the dollar to thb exchange rate."
    }
  }
end
