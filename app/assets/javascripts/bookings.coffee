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
  $('#compact_check_box').change ->
    if this.checked
      $('.cell').addClass('cell_compact')
      $('.date').addClass('date_compact')
      $('.house_code').addClass('house_code_compact')
      $('.booking_data').hide()
      $('.job').each ->
        j = $(@)
        new_top = parseInt(j.css('top').substr 0,2)-15
        j.css('top', new_top)
    else
      $('.cell').removeClass('cell_compact')
      $('.date').removeClass('date_compact')
      $('.house_code').removeClass('house_code_compact')
      $('.booking_data').show()
      $('.job').each ->
        j = $(@)
        new_top = parseInt(j.css('top').substr 0,2)+15
        j.css('top', new_top)

  $.ajax
    url: '/bookings/timeline_data',
    type: "get",
    dataType: "json",
    # data: { data_value: JSON.stringify(array) },
    data: { period: 45 },
    success: (data) ->
      console.log('Timeline ready')
      close_dates h for h in data.timeline.houses
    error: (data) ->
      console.log('Something went wrong')

close_dates = (h) ->
  for b in h.bookings
    for x_add in [0..b.length-1]
      x = b.x+x_add
      $("#x"+x+"y"+b.y).addClass('booked')
      if x_add == 0
        $("#x"+x+"y"+b.y).css("z-index", 4)
        $("#x"+x+"y"+b.y).append("<div class='booking_data'><a href="+b.id+"/edit>"+b.number+"</a></div>")
    for j, i in b.jobs
      style = "top:"+15*(i+1)+"px;background-color:"+j.color+";"
      $("#x"+j.x+"y"+b.y).css("z-index", 3)
      $("#x"+j.x+"y"+b.y).append("
        <div class='job' style="+style+">"+j.code+j.time+"</div>")
      $("#x"+j.x+"y"+b.y).data('jobs', i+1)
  for j, i in h.jobs
    jobs_qty = $("#x"+j.x+"y"+h.y).data('jobs')
    jobs_qty = if jobs_qty then jobs_qty else 0
    style = "top:"+15*(i+1+jobs_qty)+"px;background-color:"+j.color+";"
    $("#x"+j.x+"y"+h.y).css("z-index", 3)
    $("#x"+j.x+"y"+h.y).append("
      <div class='job' style="+style+">"+j.code+j.time+"</div>")

