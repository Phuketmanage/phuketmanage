$(document).on "turbolinks:load", ->
  react_to_select_user_id($('#view_user_id').val())

  # if $('form').attr('method') == 'post'
  react_to_select_trsc_type($('#trsc_type').children('option:selected').text(), true)

  $('#view_user_id').on 'change', ->
    react_to_select_user_id($(this).val())

  $('#trsc_type').on 'change', ->
    react_to_select_trsc_type($(this).children('option:selected').text(), false)

  $('#transaction_house_id').on 'change', ->
    $('#transaction_user_id option:selected').removeAttr('selected')
    $('#transaction_user_id').val('')

  $('#transaction_user_id').on 'change', ->
    $('#transaction_house_id option:selected').removeAttr('selected')
    $('#transaction_house_id').val('')

  $('#transaction_booking_id').on 'change', ->
    booking_id = $(this).val()
    $.ajax
      url: "/bookings/#{booking_id}",
      type: "get",
      dataType: "json",
      data: {},
      success: (data) ->
        console.log('Booking was read')
        b = data.booking
        start = new Date(b.start)
        start_f = "#{start.getDate()}.#{start.getMonth()+1}.#{start.getFullYear()}"
        finish = new Date(b.finish)
        finish_f = "#{finish.getDate()}.#{finish.getMonth()+1}.#{finish.getFullYear()}"
        $('#transaction_comment_en').val("Rental #{start_f} - #{finish_f}")
        $('#transaction_comment_ru').val("Аренда #{start_f} - #{finish_f}")
        $("#booking_details").html("Sale #{b.sale} - Agent #{b.agent} = #{b.sale-b.agent}/2 = #{(b.sale-b.agent)/2}, Comm: #{b.comm}/2 = #{b.comm/2}, Nett: #{b.nett}/2 = #{b.nett/2}, Client: #{b.client_details}")
      error: (data) ->
        console.log('Something went wrong')
  $ ->
    $("#balance_table").DataTable(
      scrollX: true,
      paging: false,
      columnDefs: [ { type: 'date', 'targets': [0] } ],
      order: [[ 0, 'desc' ]]
    )

  $ ->
    table = $("#balance_table_with_details").DataTable(
      scrollX: true,
      paging: false,
      columnDefs: [ { type: 'date', 'targets': [1] } ],
      order: [[ 1, 'asc' ]]
    )

    $('#balance_table_with_details tbody').on 'click', 'td.details-control', ->
      tr = $(this).closest('tr')
      row = table.row( tr )

      if row.child.isShown()
        # // This row is already open - close it
        row.child.hide()
        # tr.removeClass('shown')
        tr.find('i').removeClass('fa-minus-circle').addClass('fa-plus-circle')
      else
        # // Open this row
        row.child( tr.data('child-comment-inner') ).show();
        # tr.addClass('shown')
        tr.find('i').removeClass('fa-plus-circle').addClass('fa-minus-circle')



  $('#link_show_hidden').on 'click', (e) ->
    e.preventDefault()
    if $('.hidden_row').is(":hidden")
      $('.hidden_row').addClass('text-muted')
      $('.hidden_row').show()
    else
      $('.hidden_row').hide()

  $('#transaction_de_ow').on 'change', ->
    if $('#trsc_type').children('option:selected').text() == 'Rental'
      $('#rental_calcs').html("To owner: #{$(this).val() - $('#transaction_de_co').val()}")
  $('#transaction_de_co').on 'change', ->
    if $('#trsc_type').children('option:selected').text() == 'Rental'
      $('#rental_calcs').html("To owner: #{$('#transaction_de_ow').val() - $(this).val()}")

react_to_select_user_id = (selected) ->
  if selected > 0
    $('#btn_owner_view').attr('disabled', false)
    $('#btn_owner_front_view').attr('disabled', false)
    $('#btn_owner_accounting_view').attr('disabled', false)
  else
    $('#btn_owner_view').attr('disabled', true)
    $('#btn_owner_front_view').attr('disabled', true)
    $('#btn_owner_accounting_view').attr('disabled', true)

react_to_select_trsc_type = (selected, init) ->
    $('.money_fields').hide()
    if selected == 'Rental'
      if init == false
        $("#transaction_cr_ow").val(0)
        $("#transaction_cr_co").val(0)
      $("#booking_id").show()
      $("#de_ow_label").text('Received')
      $("#de_ow").show()
      $("#de_co_label").text('Commission')
      $("#de_co").show()
      $("#booking_support_div").show()
      $("#check_booking_paid").show()
      $("#house_id").hide()
      $("#owner_id").hide()
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Top up'
      if init == false
        $("#transaction_cr_ow").val(0)
        $("#transaction_de_co").val(0)
        $("#transaction_cr_co").val(0)
      $("#de_ow_label").text('Amount')
      $("#de_ow").show()
      $("#house_id").hide()
      $("#owner_id").show()
      if $('form').attr('method') == 'post' && init == false
        $('#transaction_comment_en').val("Balance top up")
        $('#transaction_comment_ru').val("Пополнение баланса")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Maintenance'
      if init == false
        $("#transaction_de_ow").val(0)
        $("#transaction_de_co").val(0)
        $("#transaction_cr_co").val(0)
      $("#cr_ow_label").text('Pay to outside')
      $("#cr_ow").show()
      $("#de_co_label").text('Pay to Phaethon')
      $("#de_co").show()
      $("#house_id").show()
      $("#owner_id").show()
      if $('form').attr('method') == 'post' && init == false
        $('#transaction_comment_en').val("Maintenance ")
        $('#transaction_comment_ru').val("Обслуживание ")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Laundry'
      if init == false
        $("#transaction_de_ow").val(0)
        $("#transaction_de_co").val(0)
        $("#transaction_cr_co").val(0)
      $("#cr_ow_label").text('Pay to outside')
      $("#cr_ow").show()
      $("#de_co_label").text('Pay to Phaethon')
      $("#de_co").show()
      $("#house_id").show()
      $("#owner_id").show()
      if $('form').attr('method') == 'post' && init == false
        $('#transaction_comment_en').val("Laundry ")
        $('#transaction_comment_ru').val("Стирка ")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if jQuery.inArray(selected, ['Repair','Purchases', 'Consumables', 'Improvements']) != -1
      if init == false
        $("#transaction_de_ow").val(0)
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
    if selected == 'From guests' #House required
      if init == false
        $("#transaction_cr_ow").val(0)
        $("#transaction_de_co").val(0)
        $("#transaction_cr_co").val(0)
      $("#de_ow_label").text('Amount')
      $("#de_ow").show()
      $("#house_id").show()
      $("#owner_id").hide()
      if $('form').attr('method') == 'post' && init == false
        $('#transaction_comment_en').val("Utilities from guests")
        $('#transaction_comment_ru').val("Ком платежи с гостей")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if jQuery.inArray(selected, ['Utilities', 'Yearly contracts','Insurance','To owner','Common area', 'Transfer']) != -1
      if init == false
        $("#transaction_de_ow").val(0)
        $("#transaction_de_co").val(0)
        $("#transaction_cr_co").val(0)
      $("#cr_ow_label").text('Amount')
      $("#cr_ow").show()
      $("#house_id").show()
      $("#owner_id").show()
      if $('form').attr('method') == 'post' && init == false
        $('#transaction_comment_en').val(selected)
        $('#transaction_comment_ru').val("")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if jQuery.inArray(selected, ['Salary','Gasoline','Office','Suppliers','Eqp & Cons', 'Taxes & Accounting', 'Eqp maintenance', 'Materials']) != -1
      if init == false
        $("#transaction_de_ow").val(0)
        $("#transaction_cr_ow").val(0)
        $("#transaction_de_co").val(0)
      $("#comment_ru").hide()
      $("#comment_inner").hide()
      $("#ref_no").hide()
      $("#cr_co_label").text('Amount')
      $("#cr_co").show()
      if $('form').attr('method') == 'post' && init == false
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
      if $('form').attr('method') == 'post' && init == false
        $('#transaction_comment_en').val("")
        $('#transaction_comment_ru').val("")
      $("#comment_ru").show()
      $("#comment_inner").show()


