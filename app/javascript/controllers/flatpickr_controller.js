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

  connect() {
    this.config = {
      ...this.config,
      altFormat: "d.m.y",
      altInput: true,
      dateFormat: "Y-m-d",
      locale: {
        ...this.locale,
        rangeSeparator: ' - ',
        firstDayOfWeek: 1,
      },
      mode: 'range',
    };
    super.connect();
  }

  update_attr(){
    let house_id  = $('#booking_house_id').val()
    fetch(`/bookings/get_reservations?house_id=${house_id}`)
      .then((response) => response.json())
      .then((data) => 
      this.data.set('disable', data['occupied_days']))
  }

  get locale() {
    return this.locales[this.data.get('locale')] || english;
  }
}
