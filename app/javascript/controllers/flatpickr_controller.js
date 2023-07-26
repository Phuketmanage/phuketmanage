// import stimulus-flatpickr wrapper controller to extend it
import Flatpickr from 'stimulus-flatpickr';

// you can also import a translation file
import { Russian } from 'flatpickr/dist/l10n/ru';
import { english } from 'flatpickr/dist/l10n/default';

// import a theme (could be in your main CSS entry too...)
// import 'flatpickr/dist/themes/dark.css'

// create a new Stimulus controller by extending stimulus-flatpickr wrapper controller
export default class extends Flatpickr {
  locales = {
    ru: Russian,
    en: english,
  };

  locale = {
    firstDayOfWeek: 1
  };

  connect() {
    this.config = {
      altFormat: "d.m.y",
      altInput: true,
      dateFormat: "Y-m-d",
      locale: this.locale,
      mode: 'range',
    };
    super.connect();
  }

  get locale() {
    return this.locales[this.data.get('locale')] || english;
  }
}
