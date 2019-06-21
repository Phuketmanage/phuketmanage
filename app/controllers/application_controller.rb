class ApplicationController < ActionController::Base
  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  private

    def default_url_options
        { locale: I18n.locale }
    end

    def set_locale
      if params.key?(:locale)
        I18n.locale = params[:locale]
      else
        I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
        # I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
      end
    end

end
