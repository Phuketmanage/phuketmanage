$(document).on "turbolinks:load", ->
  $('.price_amount').change ->
    id = $(this).data('id')
    array = [1, 2, 3, 4, 5];
    $.ajax
      url: '/prices/'+id+'/update',
      type: "get",
      dataType: "json",
      # data: { data_value: JSON.stringify(array) },
      data: {price: {amount:$(this).val()}},
      success: (data) ->
        console.log(data)
        $('.price_'+data.price_id).removeClass('is-invalid')
      error: (data) ->
        console.log(data)
        text = ''
        jQuery.each data.responseJSON.errors, (index, value) ->
          text += value + '\n'
        alert(text)
        $('.price_'+data.responseJSON.price_id).addClass('is-invalid')
        $('.price_'+data.responseJSON.price_id).focus()
