class ActiveStorageMaintenanceJob < ApplicationJob
  def perform
    ActiveStorage::Blob.unattached.where(created_at: ..1.day.ago).find_each(&:purge_later)
  end
end
