class Admin::NotificationsController < AdminController

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
