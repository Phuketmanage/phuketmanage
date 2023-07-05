import { DateRangePicker }  from "vanillajs-datepicker";

document.addEventListener("DOMContentLoaded", () => {
  elements = document.querySelectorAll('.js_rangepicker')
  if (elements) {
    for (elem of elements){
      occupiedDates = ''
      if (elem.dataset && elem.dataset.occupiedDates) {occupiedDates = JSON.parse(elem.dataset.occupied)}
      opts = {buttonClass: 'btn', format: 'dd.mm.yyyy', minDate: 'today', datesDisabled: occupiedDates}
      new DateRangePicker(elem, opts);
    }
  }
});
