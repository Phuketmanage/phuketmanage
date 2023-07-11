import flatpickr from "flatpickr"

document.addEventListener("DOMContentLoaded", () => {
  rp_elements = document.querySelectorAll('.js_rangepicker')
  if (rp_elements) {
    occupiedDays = ''
    for (elem of rp_elements){
      if (elem.dataset && elem.dataset.occupiedDays) {occupiedDays = JSON.parse(elem.dataset.occupiedDays)}
      opts = { altInput: true, altFormat: "d.m.Y", dateFormat: "Y-m-d", mode: "range"}
      picker = flatpickr(elem, opts)
    }
  }
})