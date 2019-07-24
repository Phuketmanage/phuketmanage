$(document).on "turbolinks:load", ->
  $('.calcs').change ->
    sale = parseInt($('#booking_sale').val())
    agent = parseInt($('#booking_agent').val())
    comm = parseInt($('#booking_comm').val())
    if sale > 0
      $('#comm_percent').text(((agent+comm)/sale*100).toFixed(1))
  $('.timeline_container').scroll ->
    $('.timeline_top_container').prop("scrollLeft", this.scrollLeft)
    $('.timeline_left_container').prop("scrollTop", this.scrollTop)

