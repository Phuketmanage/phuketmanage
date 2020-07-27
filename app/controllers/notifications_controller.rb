class NotificationsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
  end

end
