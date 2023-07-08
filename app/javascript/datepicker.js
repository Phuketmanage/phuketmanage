import { DateRangePicker }  from "vanillajs-datepicker";

document.addEventListener("DOMContentLoaded", () => {
  elements = document.querySelectorAll('.js_rangepicker')
  if (elements) {
    for (elem of elements){
      occupiedDays = ''
      if (elem.dataset && elem.dataset.occupiedDays) {occupiedDays = JSON.parse(elem.dataset.occupiedDays)}

      opts = {buttonClass: 'btn', format: 'dd.mm.yyyy', minDate: 'today', datesDisabled: occupiedDays, autohide: true, weekStart: 1}
      date_picker = new DateRangePicker(elem, opts);
      rangeStart = elem.dataset.start
      rangeEnd = elem.dataset.finish
      date_picker.setDates(rangeStart,rangeEnd)
    }
  }
});
