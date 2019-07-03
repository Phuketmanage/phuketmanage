class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_settings

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  private

    def set_settings
      @settings = Setting.all.map{|s| [s.var, s.value]}.to_h
    end

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

  protected
    def authenticate_inviter!
      # byebug
      unless user_signed_in? && current_user.role?(:admin)
        redirect_to root_path, alert: 'You are not authorized to access this page.' and return
      end
      super
    end
end
