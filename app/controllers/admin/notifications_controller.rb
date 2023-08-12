class NotificationsController < AdminController
  load_and_authorize_resource

  def index; end

  # @route DELETE (/:locale)/notifications/:id {locale: nil} (notification)
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
  end
end
