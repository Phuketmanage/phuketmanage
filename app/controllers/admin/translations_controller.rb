class Admin::TranslationsController < AdminController

  authorize_resource class: false
  # @route GET /translate (translate)
  def show
    translation = translate(params['text'], params['language'])
    render plain: translation
  end

  private

  def translate(text, language)
    EasyTranslate.translate(text, to: language)
  end
end
