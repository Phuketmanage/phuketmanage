$(document).on "turbolinks:load", ->
  $('#trsc_type').on 'change', ->
    selected =  $(this).children('option:selected').text()
    $('.money_fields').hide()
    if selected == 'Maintenance'
      $("#cr_ow_label").text('Maintenance price')
      $("#cr_ow").show()
    if selected == 'Rental'
      $("#de_ow_label").text('Received')
      $("#de_ow").show()
      $("#de_co_label").text('Commission')
      $("#de_co").show()
    if selected == 'Top up'
      $("#de_ow_label").text('Amount')
      $("#de_ow").show()
    if selected == 'Repair' || selected == 'Purchases'
      $("#cr_ow_label").text('Expences by owner')
      $("#cr_ow").show()
      $("#cr_co_label").text('Expences by company')
      $("#cr_co").show()
      $("#de_co_label").text('Company profit')
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
    # if selected == 'Salary' || selected == 'Gasoline' || selected == 'Office'
    if jQuery.inArray(selected, ['Salary','Gasoline','Office','Suppliers','Equipment']) != -1
      $("#house_id").hide()
      $("#owner_id").hide()
      $("#comment_ru").hide()
      $("#comment_inner").hide()
      $("#ref_no").hide()
      $("#cr_co_label").text('Amount')
      $("#cr_co").show()


