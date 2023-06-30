$(document).ready(function () {
  elem = document.getElementById('rangepicker')
  occupiedDates = ''
  if (elem.dataset.occupied) {occupiedDates = JSON.parse(el_rs.dataset.occupied)}
  opts = {buttonClass: 'btn', format: 'dd.mm.yyyy', minDate: 'today', datesDisabled: occupiedDates}
  const rangepicker = new DateRangePicker(elem, opts); 
});
    