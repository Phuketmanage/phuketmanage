$(document).on "ready", ->
  $('#search_rs').change ->
    rs = moment(this.value)
    rf_min = rs.add(5, 'days').format("YYYY-MM-DD")
    console.log rf_min
    $('#search_rf').attr('min', rf_min)
    $('#search_rf').val(rf_min)

