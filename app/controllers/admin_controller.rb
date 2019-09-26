class AdminController < ApplicationController
  load_and_authorize_resource
  before_action :set_en_locale
  def index
  end

  private

    def set_en_locale
      I18n.locale = "en"
    end

end
