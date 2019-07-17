desc "Sync all bookings"
task sync_bookings: :environment do
  puts "Syncing bookings..."
  Booking.sync
  puts "Booking synced"
end
