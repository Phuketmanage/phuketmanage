$(document).on "turbolinks:load", ->
  react_to_select_user_id($('#user_id').val())
  react_to_select_trsc_type($('#trsc_type').children('option:selected').text())

  $('#user_id').on 'change', ->
    react_to_select_user_id($(this).val())

  $('#trsc_type').on 'change', ->
    react_to_select_trsc_type($(this).children('option:selected').text())

  $('#transaction_booking_id').on 'change', ->
    booking_id = $(this).val()
    $.ajax
      url: "/bookings/#{booking_id}",
      type: "get",
      dataType: "json",
      data: {},
      success: (data) ->
        console.log('Booking was read')
        start = new Date(data.booking.start)
        start_f = "#{start.getDate()}.#{start.getMonth()+1}.#{start.getFullYear()}"
        finish = new Date(data.booking.finish)
        finish_f = "#{finish.getDate()}.#{finish.getMonth()+1}.#{finish.getFullYear()}"
        $('#transaction_comment_en').val("Rental #{start_f} - #{finish_f}")
        $('#transaction_comment_ru').val("Аренда #{start_f} - #{finish_f}")
      error: (data) ->
        console.log('Something went wrong')

  $('#link_show_hidden').on 'click', (e) ->
    e.preventDefault()
    if $('.hidden_row').is(":hidden")
      $('.hidden_row').addClass('text-muted')
      $('.hidden_row').show()
    else
      $('.hidden_row').hide()

react_to_select_user_id = (selected) ->
  if selected > 0
    $('#btn_owner_view').attr('disabled', false)
    $('#btn_owner_accounting_view').attr('disabled', false)
  else
    $('#btn_owner_view').attr('disabled', true)
    $('#btn_owner_accounting_view').attr('disabled', true)

react_to_select_trsc_type = (selected) ->
    $('.money_fields').hide()
    if selected == 'Rental'
      $("#booking_id").show()
      $("#de_ow_label").text('Received')
      $("#de_ow").show()
      $("#de_co_label").text('Commission')
      $("#de_co").show()
      $("#check_booking_paid").show()
      $("#house_id").hide()
      $("#owner_id").hide()
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Top up'
      $("#de_ow_label").text('Amount')
      $("#de_ow").show()
      $("#house_id").hide()
      $("#owner_id").show()
      if $('input[name=_method]').val() == 'post'
        $('#transaction_comment_en').val("Balance top up")
        $('#transaction_comment_ru').val("Пополнение баланса")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Maintenance'
      $("#cr_ow_label").text('Maintenance price')
      $("#cr_ow").show()
      $("#house_id").hide()
      $("#owner_id").show()
      if $('input[name=_method]').val() == 'post'
        $('#transaction_comment_en').val("Maintenance")
        $('#transaction_comment_ru').val("")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Repair' || selected == 'Purchases'
      if $('input[name="_method"]').val() == 'patch'
        cr_ow = $("#transaction_cr_ow").val() - $("#transaction_de_co").val()
        de_co = $("#transaction_de_co").val() - $("#transaction_cr_co").val()
        $("#transaction_cr_ow").val(cr_ow)
        $("#transaction_de_co").val(de_co)
      $("#cr_ow_label").text('Expences by owner')
      $("#cr_ow").show()
      $("#cr_co_label").text('Expences by company')
      $("#cr_co").show()
      $("#de_co_label").text('Company profit')
      $("#de_co").show()
      $("#house_id").show()
      $("#owner_id").hide()
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Laundry'
      $("#cr_ow_label").text('Amount')
      $("#cr_ow").show()
      $("#house_id").show()
      $("#owner_id").hide()
      if $('input[name=_method]').val() == 'post'
        $('#transaction_comment_en').val("Laundry")
        $('#transaction_comment_ru').val("Стирка")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Utilities received' #House required
      $("#de_ow_label").text('Amount')
      $("#de_ow").show()
      $("#house_id").show()
      $("#owner_id").hide()
      if $('input[name=_method]').val() == 'post'
        $('#transaction_comment_en').val("Utilities from guests")
        $('#transaction_comment_ru').val("")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Utilities'
      $("#cr_ow_label").text('Paid by owner')
      $("#cr_ow").show()
      $("#cr_co_label").text('Paid by company')
      $("#cr_co").show()
      $("#house_id").show()
      $("#owner_id").hide()
      if $('input[name=_method]').val() == 'post'
        $('#transaction_comment_en').val("")
        $('#transaction_comment_ru').val("")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Pest control' || selected == 'Insurance'
      $("#cr_ow_label").text('Amount')
      $("#cr_ow").show()
      $("#house_id").show()
      $("#owner_id").show()
      if $('input[name=_method]').val() == 'post'
        $('#transaction_comment_en').val(selected)
        $('#transaction_comment_ru').val("")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if jQuery.inArray(selected, ['Salary','Gasoline','Office','Suppliers','Equipment']) != -1
      $("#comment_ru").hide()
      $("#comment_inner").hide()
      $("#ref_no").hide()
      $("#cr_co_label").text('Amount')
      $("#cr_co").show()
      if $('input[name=_method]').val() == 'post'
        $('#transaction_comment_en').val(selected)
      $("#house_id").hide()
      $("#owner_id").hide()
    if selected == 'Other'
      $("#house_id").show()
      $("#owner_id").show()
      $("#de_ow_label").text('Debit Owner')
      $("#de_ow").show()
      $("#cr_ow_label").text('Credit Owner')
      $("#cr_ow").show()
      $("#de_co_label").text('Debit Company')
      $("#de_co").show()
      $("#cr_co_label").text('Credit Company')
      $("#cr_co").show()
      if $('input[name=_method]').val() == 'post'
        $('#transaction_comment_en').val("")
        $('#transaction_comment_ru').val("")
      $("#comment_ru").show()
      $("#comment_inner").show()

