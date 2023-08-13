class Admin::NotificationsController < ApplicationController
  load_and_authorize_resource

  def index; end

  # @route DELETE /notifications/:id (notification)
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
  end
end
