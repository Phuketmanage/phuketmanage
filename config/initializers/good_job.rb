Rails.application.configure do
  config.good_job.execution_mode = :external
  config.good_job.queues = 'default:5'
  config.good_job.enable_cron = true
  config.good_job.smaller_number_is_higher_priority = true

  # Uncomment when active storage will be available
  #
  # config.good_job.cron = {
  #   storage_maintenance: { # each recurring job must have a unique key
  #     cron: "5 0 * * *", # cron-style scheduling format by fugit gem
  #     class: "ActiveStorageMaintenanceJob", # reference the Job class with a string
  #     set: { priority: 10 }, # additional ActiveJob properties; can also be a lambda/proc e.g. `-> { { priority: [1,2].sample } }`
  #     description: "Purges unattached Active Storage blobs." # optional description that appears in Dashboard
  #   }
  # }
end
