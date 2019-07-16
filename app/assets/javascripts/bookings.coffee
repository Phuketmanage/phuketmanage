$(document).on "turbolinks:load", ->
  $('.calcs').change ->
    sale = parseInt($('#booking_sale').val())
    agent = parseInt($('#booking_agent').val())
    comm = parseInt($('#booking_comm').val())
    if sale > 0
      $('#comm_percent').text(((agent+comm)/sale*100).toFixed(1))
