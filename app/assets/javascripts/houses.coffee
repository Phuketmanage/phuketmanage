$(document).on "ready", ->
  # Filtering a list as you type by house code
  $('#search_house').on "keyup", (e) ->
    value = $(this).val().toLowerCase()
    $('div[data-house-code]').each (index, element) ->
      if $(element).data('house-code').toLowerCase().search(value) > -1
        $(element).show()
      else
        $(element).hide()



