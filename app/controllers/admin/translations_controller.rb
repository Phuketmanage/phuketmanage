class Admin::TranslationsController < ApplicationController

  authorize_resource class: false
  # @route GET (/:locale)/translate {locale: nil} (translate)
  def show
    translation = translate(params['text'], params['language'])
    render plain: translation
  end

  private

  def translate(text, language)
    EasyTranslate.translate(text, to: language)
  end
end
