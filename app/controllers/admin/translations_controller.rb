class Admin::TranslationsController < AdminController
  verify_authorized

  # @route GET /translate (translate)
  def show
    authorize! with: Admin::TranslationPolicy
    translation = translate(params['text'], params['language'])
    render plain: translation
  end

  private

  def translate(text, language)
    EasyTranslate.translate(text, to: language)
  end
end
