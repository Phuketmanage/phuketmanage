$(document).on "turbolinks:load", ->
  $('.calcs').change ->
    sale = $('#booking_sale').val()
    comm = $('#booking_comm').val()
    if sale > 0
      $('#comm_percent').text((comm/sale*100).toFixed(1))
