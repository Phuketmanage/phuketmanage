$(document).on "turbolinks:load", ->
  $('#document_date').on 'change', ->
    date = new Date($(this).val())
    month = (date.getMonth()+1).toString()
    new_month = ('0'+month).slice(-2)
    new_date = "#{date.getDate()}.#{new_month}.#{date.getFullYear()}"
    $('#doc_date').text(new_date)
    code = $('input#document_code').val()
    run_number = $('#run_number').val()
    new_run_number  = '0'.repeat(3-run_number.length) + run_number
    $('#st_number').text("SO-#{code}-#{date.getFullYear()}#{new_month}#{new_run_number}")
    $('#rb_number').text("RB-#{code}-#{date.getFullYear()}#{new_month}#{new_run_number}")
  $('#run_number').on 'change', ->
    new_run_number  = '0'.repeat(3-$(this).val().length) + $(this).val()
    st_old_number = $('#st_number').text()
    st_new_number = st_old_number.replace(/\d{3}$/,new_run_number)
    $('#st_number').text(st_new_number)
    rb_old_number = $('#rb_number').text()
    rb_new_number = rb_old_number.replace(/\d{3}$/,new_run_number)
    $('#rb_number').text(rb_new_number)
  $('#document_amount').on 'change', ->
    new_amount_raw = $(this).val()
    new_amount = parseFloat(new_amount_raw.replace(',', '.')).toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
    $('#doc_amount').text(new_amount)
    $('#doc_total_thb').text(new_amount)
    usd = $('#document_usd').val()
    usd_raw =new_amount_raw/usd
    new_amount_usd = usd_raw.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
    $('#doc_total_usd').text(new_amount_usd)
  $('#document_customer').on 'change', ->
    $('#doc_customer').text($(this).val())
  $('#document_address').on 'change', ->
    $('#doc_address').text($(this).val())
  $('#document_add_text').on 'change', ->
    $('#doc_add_text').text($(this).val())
  $('input[type=radio]').on 'click', ->
    console.log $(this).val()
    $('span[data-checkmark]').hide()
    $("span##{$(this).val()}").show()
