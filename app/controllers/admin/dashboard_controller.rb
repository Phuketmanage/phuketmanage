class Admin::DashboardController < AdminController
  authorize_resource class: false
  # @route GET /dashboard (dashboard)
  def index
    redirect_to water_usages_path if current_user.role?('Gardener')
    redirect_to transactions_path and return if current_user.role?('Owner')

    @notifications = Notification.order(:created_at).all
    @bookings = Booking.pending
  end
end
