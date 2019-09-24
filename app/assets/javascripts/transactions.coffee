$(document).on "turbolinks:load", ->
  react_to_select_user_id($('#user_id').val())
  react_to_select_trsc_type($('#trsc_type').children('option:selected').text())

  $('#user_id').on 'change', ->
    react_to_select_user_id($(this).val())

  $('#trsc_type').on 'change', ->
    react_to_select_trsc_type($(this).children('option:selected').text())

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
      $("#de_ow_label").text('Received')
      $("#de_ow").show()
      $("#de_co_label").text('Commission')
      $("#de_co").show()
    if selected == 'Top up'
      $("#de_ow_label").text('Amount')
      $("#de_ow").show()
    if selected == 'Maintenance'
      $("#cr_ow_label").text('Maintenance price')
      $("#cr_ow").show()
    if selected == 'Repair' || selected == 'Purchases'
      $("#cr_ow_label").text('Expences by owner')
      $("#cr_ow").show()
      $("#cr_co_label").text('Expences by company')
      $("#cr_co").show()
      $("#de_co_label").text('Company profit')
      if $('input[name="_method"]').val() == 'patch'
        cr_ow = $("#transaction_cr_ow").val() - $("#transaction_de_co").val()
        de_co = $("#transaction_de_co").val() - $("#transaction_cr_co").val()
        $("#transaction_cr_ow").val(cr_ow)
        $("#transaction_de_co").val(de_co)
      $("#de_co").show()
    if selected == 'Laundry'
      $("#cr_ow_label").text('Amount')
      $("#cr_ow").show()
    if selected == 'Utilities received' #House required
      $("#de_ow_label").text('Amount')
      $("#de_ow").show()
    if selected == 'Utilities'
      $("#cr_ow_label").text('Paid by owner')
      $("#cr_ow").show()
      $("#cr_co_label").text('Paid by company')
      $("#cr_co").show()
    if selected == 'Pest control' || selected == 'Insurance'
      $("#cr_ow_label").text('Amount')
      $("#cr_ow").show()
    if jQuery.inArray(selected, ['Salary','Gasoline','Office','Suppliers','Equipment']) != -1
      $("#house_id").hide()
      $("#owner_id").hide()
      $("#comment_ru").hide()
      $("#comment_inner").hide()
      $("#ref_no").hide()
      $("#cr_co_label").text('Amount')
      $("#cr_co").show()
