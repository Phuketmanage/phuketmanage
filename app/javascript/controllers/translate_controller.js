import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["inputEn", "inputRu"]
  static values = { url: { type: String, default: '/translate' } }

  en2ru = async () => {
    try {
      const response = await this.load_translation(this.inputEnTarget.value, 'ru');
      this.inputRuTarget.value = response;
    } catch (error) {
      console.error(error);
    }
  };

  ru2en = async () => {
    try {
      const response = await this.load_translation(this.inputRuTarget.value, 'en');
      this.inputEnTarget.value = response;
    } catch (error) {
      console.error(error);
    }
  };



  async load_translation(text, to_lang) {
    try {
      const response = await fetch(`${this.urlValue}?text=${text}&language=${to_lang}`, {
        method: "GET"
      })
      const output = await response.text()
      return output
    } catch (error) {
      console.error(error)
    }
  }
}
