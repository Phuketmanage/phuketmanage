class AdminController < ApplicationController
  load_and_authorize_resource
  before_action :set_en_locale
  # @route GET /owner (owner)
  # @route GET (/:locale)/dashboard (dashboard)
  def index
    if current_user.role?('Gardener')
      redirect_to water_usages_path
    end
    if current_user.role?('Owner')
      redirect_to transactions_path and return
    end
    @notifications = Notification.order(:created_at).all
  end

  private

    def set_en_locale
      I18n.locale = "en"
    end

end
