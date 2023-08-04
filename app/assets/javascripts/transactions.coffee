$(document).on "ready", ->
  # show files from transaction list
  $('a[data-show-files]').on "click", (e) ->
    e.preventDefault()
    $.ajax
      url: "/transaction_files",
      type: "get",
      dataType: "json",
      data: {
        transaction_id: $(this).data('transaction')
      },
      success: (data) ->
        modal = $('#transaction_files')
        file_current = modal.find('div.file_current')
        files_carousel = modal.find('div.files_carousel')
        files_host = $('#files_host').val()
        src = files_host + data['files'][0]['url']
        extention = data['files'][0]['url'].split('.').pop().toLowerCase()
        height = $(window).height()-300
        if extention == 'pdf'
          file_current.html($("<embed />", {src: src, type: "application/pdf", width: '100%', height: '100%' }))
        else
          file_current.html($("<img />", {src: src, class: 'file_image'}))
        files_carousel.empty()
        for f in data['files']
          extention = data['files'][0]['url'].split('.').pop().toLowerCase()
          height = $(window).height()-350
          extention = f['url'].split('.').pop()
          src = files_host + f['url']
          link = $("<a>", {href: '#', 'data-link-preview': src, class: 'link_for_preview'})
          if extention == 'pdf'
            file = $("<embed />", {src: src, type: "application/pdf", width: '150px', height: '150px', class: 'pdf_preview' })
          else
            file = $("<img />", {src: src, class: 'image_preview'})
          preview = link.html(file)
          files_carousel.append(preview)
        $('div.file_current').height(height = $(window).height()-350)
        $('#transaction_files').modal()
      fail: (data) ->
        console.log 'Can not read files'

  # cilck on preview of transaction file
  $('#transaction_files').on 'click', 'a[data-link-preview]', (e) ->
    e.preventDefault()
    src = $(this).data('link-preview')
    modal = $('#transaction_files')
    file_current = modal.find('div.file_current')
    extention = src.split('.').pop().toLowerCase()
    # height = $(window).height()-300
    if extention == 'pdf'
      file_current.html($("<embed />", {src: src, type: "application/pdf", width: '100%', height: '100%' }))
    else
      # file_current.html($("<img />", {src: src, width: '100%', class: 'img-fluid'}))
        # file_current.html($("<embed />", {src: src, type: "image/jpg", width: '100%', height: '100%' }))
        file_current.html($("<img />", {src: src, class: 'file_image' }))

  react_to_select_house($('#view_house_id').val())

  react_to_select_trsc_type($('#trsc_type').children('option:selected').text(), true)

  $('#balance_of').on 'click', (e) ->
    $(this).select()

  # Filtering a list as you type by house code or owner name
  $('#balance_of').on 'keyup', (e) ->
    value = $(this).val().toLowerCase()
    $(".dropdown-menu a").filter (e) ->
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    if value == ""
      $('#owner_id').val($(this).data('owner-id'))
      react_to_select_house($(this).data('house-id'))

  # Filtering a list as you type by house code or owner name
  $('#for_house').on 'keyup', (e) ->
    value = $(this).val().toLowerCase()
    $(".dropdown-menu a").filter (e) ->
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    if value == ""
      $('#owner_id').val($(this).data('owner-id'))
      react_to_select_house($(this).data('house-id'))


  # Show houses for select if owner have more than 1
  $('div.dropdown-menu[aria-labelledby="balance_of"] a').on 'click', (e) ->
    e.preventDefault()
    $('#balance_of').val($(this).data('owner-name'))
    $('#owner_id').val($(this).data('owner-id'))
    $('#for_house').val('')
    $('#house_id').val('')
    $('div.dropdown-menu[aria-labelledby="for_house"]').empty()
    $.ajax
      url: "/users/get_houses",
      type: "get",
      dataType: "json",
      data: {
        owner_id: $(this).data('owner-id')
      },
      success: (data) ->
        $('#house_id').empty()
        li = $('<option/>', {text: 'All', value: ''})
        $('#house_id').append(li)
        console.log data['houses'].length
        if data['houses'].length <= 1
          $('#house_id').prop('disabled', true);
          $('#house_id').hide()
        if data['houses'].length > 1
          $('#house_id').prop('disabled', false);
          $('#house_id').show()
          for h in data['houses']
            li = $('<option/>', {text: h['code'], value: h['id']})
            $('#house_id').append(li)
        li = $('<option/>', {text: 'Unlinked', value: 'unlinked'})
        $('#house_id').append(li)
      error: (data) ->
        console.log('Something went wrong')
    react_to_select_house($(this).data('house-id'))

  $('div.for_house').on 'click', 'div.dropdown-menu[aria-labelledby="for_house"] a', (e) ->
    e.preventDefault()
    $('#for_house').val($(this).text())
    $('#house_id').val($(this).data('house-id'))

  $('#trsc_type').on 'change', ->
    react_to_select_trsc_type($(this).children('option:selected').text(), false)

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

  fileInput = $('#fileupload_trsc')
  if fileInput.length > 0
    form = $(fileInput.parents('form:first'))
    submitButton = form.find('input[type="submit"]')
    progressBar  = $('.progress-bar')
    awsFormData = form.data('form-data')
    formData = new FormData()
    Object.keys(awsFormData).forEach (key) ->
      formData.append(key, awsFormData[key])

    fileInput.on 'change', (e) ->
      e.preventDefault
      loaded = 0
      totalSize = 0
      for file in e.target.files
        totalSize += file.size
      for file in e.target.files
        date = new Date($('#transaction_date').val())
        year = date.getFullYear()
        month = ("0" + (date.getMonth() + 1)).slice(-2)
        day = date.getDate()
        house = $('#transaction_house_id').children("option:selected").text()
        if house.length > 0 and house != 'Select house' then house = house+' - ' else house = ''
        text = $('#transaction_comment_en').val()
        oldname = file.name
        extention = oldname.split('.').pop()
        newname = year+'.'+month+'.'+day+' '+house+text+' '+(new Date).getTime()+'.'+extention
        newname = newname.replace("/", "-")
        newname = newname.replace(".", "-")
        formData.set('Content-Type', file.type)
        formData.set('file', file, newname)
        $.ajax
          xhr: ->
            xhr = new window.XMLHttpRequest()
            xhr.upload.addEventListener "progress", (evt) ->
              if (evt.lengthComputable)
                progress =  (loaded + evt.loaded) / totalSize * 100
                progressBar.css('width', progress + '%')
            , false
            return xhr
          url: form.data('url')
          type: 'POST'
          processData:false
          contentType: false
          paramName: 'file'
          dataType: 'XML'
          data: formData
          beforeSend: (e) ->
            submitButton.prop('disabled', true)
            progressBar.show()
            progressBar.css('width', '0%')
          success: (data) ->
            submitButton.prop('disabled', false)
            progressBar.hide()
            progressBar.css('width', '0%')
            loaded += file.size
            key   = $(data).find('Key').text()
            url   = key
            src = '//' + form.data('host') + '/' + key
            input = $("<input />", { type:'hidden', name: 'transaction[files][]', value: url})
            form.append(input)
            div = $('<div></div>', {class: 'shadow-sm mr-md-2 mt-2 p-2 border rounded bg-warning'})
            extention = key.split('.').pop()
            if extention == 'pdf'
              attachment = $('<embed></embed>', {src: src, width: '250px', height: '250px'})
            else
              attachment = $('<img />', {src: src, width: '250px'})
            div.append(attachment)
            show_checkbox = $('<input />', {type: 'checkbox', 'data-show-file': '','data-key': key})
            show_label = $('<label></label>', {text: 'Show'})
            link = $('<a></a>', {href: '#', text: 'Delete', 'data-delete-tmp-file': '', 'data-key': key, })
            div.append('<br />')
            div.append(show_checkbox)
            div.append(show_label)
            div.append(' ')
            div.append(link)
            $('div#transaction_files').append(div)
          fail: (data) ->
            console.log data.jqXHR.responseText

    $('#transaction_files').on "click", "a[data-link-to-file]", (e) ->
      e.preventDefault()
      url = $(this).children('img:first').attr('src')
      $('div.modal-body').html("<img src='#{url}' width='100%'>")
      $('#transaction_file').modal()

    $('#transaction_files').on "click", "div a[data-delete-tmp-file]", (e) ->
      e.preventDefault()
      $("input[value='"+$(this).data('key')+"']").remove()
      $.ajax
        url: "/transaction_file_tmp",
        type: "delete",
        dataType: "json",
        data: {
          key: $(this).data('key')
        },
        success: (data) ->
          $("a[data-key='#{data.key}']").closest('div').remove()
        fail: (data) ->
          console.log 'Can not delete file'

    $('#transaction_files').on "click", "div input[data-show-file]", (e) ->
      key = $(this).data('key')
      if $(this).prop('checked') == true
        input = $("input[value='"+key+"']")
        input_after = $("<input />", { type:'hidden', name: 'transaction[files_to_show][]', value: key})
        input.after(input_after)
      else
        $("input[name='transaction[files_to_show][]'][value='"+key+"']").remove()

    $('#transaction_back').on 'click', (e) ->
      e.preventDefault()
      $('a[data-delete-tmp-file]').each ->
        $.ajax
          url: "/transaction_file_tmp",
          type: "delete",
          dataType: "json",
          data: {
            key: $(this).data('key')
          },
          success: (data) ->
            $("a[data-key='#{data.key}']").closest('div').remove()
          fail: (data) ->
            console.log 'Can not delete file'
      window.location = $(this).attr('href')

    $('a[data-print]').on 'click', (e) ->
      e.preventDefault()
      printJS("https:#{$(this).data('print')}", $(this).data('type'))

    $('input[name=show_file]').on 'click', (e) ->
      $.ajax
        url: "/transaction_file_toggle_show",
        type: "get",
        dataType: "json",
        data: {
          id: $(this).data('id'),
          status: $(this).val()
        },
        beforeSend: (data) ->
          submitButton.prop('disabled', true)
        success: (data) ->
          submitButton.prop('disabled', false)
          text = $('<span></span>', {text: 'OK', id: "file_status_change_#{data['id']}", class: 'badge badge-success'})
          $("label[for=show_file_#{data['id']}").after(text)
          $("span#file_status_change_#{data['id']}").fadeOut('slow')
        error: (data) ->
          console.log 'Can not update show status'
          text = $('<span></span>', {text: 'Error', id: "file_status_change_#{data['id']}", class: 'badge badge-danger'})
          $("label[for=show_file_#{data['id']}").after(text)
          $("span#file_status_change_#{data['id']}").fadeOut('slow')
          checkbox = $("input#show_file_#{data['id']}")
          if checkbox.prop('checked') == true
            checkbox.prop('checked', false)
          else
            checkbox.prop('checked',true)
  #Check warnings
  $('#transaction_comment_en').on "change", (e) ->
    check_warnings(
      "text",
      '',
      $("#transaction_user_id").children("option:selected").val(),
      $(this).attr('id'),
      $(this).val())
  $('#transaction_comment_ru').on "change", (e) ->
    check_warnings(
      "text",
      '',
      $("#transaction_user_id").children("option:selected").val(),
      $(this).attr('id'),
      $(this).val())
  $('#transaction_de_co').on "change", (e) ->
    if parseInt($('#transaction_cr_co').val()) > 0
      amount = parseInt($(this).val()) + parseInt($('#transaction_cr_co').val())
      is_sum = 'true'
    else
      is_sum = ''
      amount = $(this).val()
    check_warnings(
      "number",
      is_sum,
      $("#transaction_user_id").children("option:selected").val(),
      $(this).attr('id'),
      amount)
  $('#transaction_cr_co').on "change", (e) ->
    check_warnings(
      "number",
      '',
      $("#transaction_user_id").children("option:selected").val(),
      $(this).attr('id'),
      $(this).val())
  $('#transaction_de_ow').on "change", (e) ->
    check_warnings(
      "number",
      '',
      $("#transaction_user_id").children("option:selected").val(),
      $(this).attr('id'),
      $(this).val())
  $('#transaction_cr_ow').on "change", (e) ->
    check_warnings(
      "number",
      '',
      $("#transaction_user_id").children("option:selected").val(),
      $(this).attr('id'),
      $(this).val())
  $('a[data-add-comm]').on "click", (e) ->
    e.preventDefault()
    add = $(this).data('add')
    de_ow = parseFloat($('#transaction_de_ow').val())
    cr_ow = parseFloat($('#transaction_cr_ow').val())
    cr_co = parseFloat($('#transaction_cr_co').val())

    if isNaN(de_ow) then de_ow = 0
    if isNaN(cr_ow) then cr_ow = 0
    if isNaN(cr_co) then cr_co = 0
    $('#transaction_de_co').val(Math.round((de_ow+cr_ow+cr_co)*add/100))

check_warnings = (type, is_sum, user_id, field, text) ->
  date = $('#transaction_date').val()
  if date != ""
    $.ajax
      url: "/transaction_warnings",
      type: "get",
      dataType: "json",
      data: {
        type: type
        is_sum: is_sum
        date: date,
        user_id: user_id
        field: field,
        text: text
      },
      success: (data) ->
        $("div[data-input-warning=#{data['field']}]").remove()
        if data['warning'] != ""
          div = $("<div/>", {
            class: 'text-danger',
            'data-input-warning': data['field'],
            text: data['warning']})
          $("##{data['field']}").parent().append div
      error: (data) ->
        console.log 'Can not check warnings'

react_to_select_house = (selected) ->
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
        $("#transaction_cr_ow").val('')
        $("#transaction_cr_co").val('')
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
        $("#transaction_cr_ow").val('')
        $("#transaction_de_co").val('')
        $("#transaction_cr_co").val('')
      $("#de_ow_label").text('Amount')
      $("#de_ow").show()
      $("#house_id").show()
      $("#owner_id").show()
      if $('form').attr('method') == 'post' && init == false
        $('#transaction_comment_en').val("Balance top up")
        $('#transaction_comment_ru').val("Пополнение баланса")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Maintenance'
      if init == false
        $("#transaction_de_ow").val('')
        $("#transaction_de_co").val('')
        $("#transaction_cr_co").val('')
      $("#cr_ow_label").text('Owner paid')
      $("#cr_ow").show()
      $("#de_co_label").text('To Phaethon')
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
        $("#transaction_de_ow").val('')
        $("#transaction_de_co").val('')
        $("#transaction_cr_co").val('')
      $("#cr_ow_label").text('Pay to outside')
      $("#cr_ow").show()
      $("#de_co_label").text('Pay to Phaethon')
      $("#de_co").show()
      $("#house_id").show()
      $("#owner_id").show()
      if $('form').attr('method') == 'post' && init == false
        $('#transaction_comment_en').val("Laundry")
        $('#transaction_comment_ru').val("Стирка")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Cleaning'
      if init == false
        $("#transaction_de_ow").val('')
        $("#transaction_de_co").val('')
        $("#transaction_cr_co").val('')
      $("#de_co_label").text('Pay to Phaethon')
      $("#de_co").show()
      $("#house_id").show()
      $("#owner_id").show()
      if $('form').attr('method') == 'post' && init == false
        $('#transaction_comment_en').val("Cleaning")
        $('#transaction_comment_ru').val("Уборка")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if selected == 'Welcome packs'
      if init == false
        $("#transaction_de_ow").val('')
        $("#transaction_de_co").val('')
        $("#transaction_cr_co").val('')
      $("#de_co_label").text('Pay to Phaethon')
      $("#de_co").show()
      $("#house_id").show()
      $("#owner_id").show()
      if $('form').attr('method') == 'post' && init == false
        $('#transaction_comment_en').val("Welcome packs")
        $('#transaction_comment_ru').val("Приветственные наборы")
      $("#comment_ru").show()
      $("#comment_inner").show()
    if jQuery.inArray(selected, ['Repair','Purchases', 'Consumables', 'Improvements']) != -1
      if init == false
        $("#transaction_de_ow").val('')
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
        $("#transaction_cr_ow").val('')
        $("#transaction_de_co").val('')
        $("#transaction_cr_co").val('')
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
        $("#transaction_de_ow").val('')
        $("#transaction_de_co").val('')
        $("#transaction_cr_co").val('')
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
        $("#transaction_de_ow").val('')
        $("#transaction_cr_ow").val('')
        $("#transaction_de_co").val('')
      $("#transaction_user_id").val([])
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
