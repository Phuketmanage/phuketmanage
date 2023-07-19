import flatpickr from "flatpickr"
import { Russian } from "flatpickr/dist/l10n/ru.js"

document.addEventListener("DOMContentLoaded", () => {
  rp_elements = document.querySelectorAll('.js_rangepicker')
  if (rp_elements) {
    element_opts = {}
    for (elem of rp_elements){
      if (elem.dataset) { 
        element_opts = JSON.stringify(elem.dataset)
        elem.dataset.locale == 'ru' ?  element_opts.locale = Russian : delete element_opts.locale
      }
      default_opts = { altInput: true, altFormat: "d.m.Y", dateFormat: "Y-m-d", mode: "range" }
      opts = { ...default_opts, ...element_opts }
      picker = flatpickr(elem, opts)
    }
  }
})