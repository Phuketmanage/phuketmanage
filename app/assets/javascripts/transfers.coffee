$(document).on "turbolinks:load", ->
  $('#trsc_type').on 'change', ->
    selected =  $(this).children('option:selected').text()
    if selected == 'Maintenance'
      console.log '123'
    $('.money_fields').show()
