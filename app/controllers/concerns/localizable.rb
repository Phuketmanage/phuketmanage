module Localizable
  extend ActiveSupport::Concern
  include HttpAcceptLanguage::AutoLocale
  included do
    before_action :set_locale
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  private

  def set_locale
    I18n.locale = if params.key?(:locale)
      I18n.available_locales.map(&:to_s).include?(params[:locale]) ? params[:locale] : I18n.default_locale
    else
      I18n.default_locale
    end
  end
end
