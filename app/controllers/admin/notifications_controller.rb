class Admin::NotificationsController < AdminController
  verify_authorized

  def index
    authorize!
  end

  # @route DELETE /notifications/:id (notification)
  def destroy
    authorize!
    @notification = Notification.find(params[:id])
    @notification.destroy
  end
end
