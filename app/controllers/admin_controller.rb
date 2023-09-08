class AdminController < ApplicationController
  before_action :set_locale

  layout 'admin'

  private

  def set_locale
    I18n.locale = if current_user && current_user.locale
      current_user.locale
    else
      I18n.default_locale
    end
  end
end
