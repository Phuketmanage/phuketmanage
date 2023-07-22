// import stimulus-flatpickr wrapper controller to extend it
import Flatpickr from 'stimulus-flatpickr'

// you can also import a translation file
import { Russian } from 'flatpickr/dist/l10n/ru.js'
import { english } from "flatpickr/dist/l10n/default.js";

// import a theme (could be in your main CSS entry too...)
// import 'flatpickr/dist/themes/dark.css'

// create a new Stimulus controller by extending stimulus-flatpickr wrapper controller
export default class extends Flatpickr {
  locales = {
    ru: Russian,
    en: english
  };

  connect() {
    // sets your language (you can also set some global setting for all time pickers)
    this.config = {
      locale: this.locale,
      dateFormat: "d.m.Y",
      mode: "range"
    }
    super.connect();
  }

  get locale() {
    if (this.locales && this.data.has("locale")) {
      return this.locales[this.data.get("locale")];
    } else {
      return "";
    }
  }
}
