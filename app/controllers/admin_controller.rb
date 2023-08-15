class AdminController < ApplicationController
  before_action :set_en_locale
  # @route GET /dashboard (dashboard)

  private

  def set_en_locale
    I18n.locale = :en
  end
end
