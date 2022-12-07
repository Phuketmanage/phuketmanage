$(document).on "turbolinks:load", ->

  if !!document.getElementById('timeline')
    $('[data-toggle="tooltip"]').tooltip()

    $('.calcs').change ->
      sale = parseInt($('#booking_sale').val())
      agent = parseInt($('#booking_agent').val())
      comm = parseInt($('#booking_comm').val())
      if sale > 0
        $('#comm_percent').text(((agent+comm)/sale*100).toFixed(1))
    $('.timeline_container').scroll ->
      $('.timeline_top_container').prop("scrollLeft", this.scrollLeft)
      $('.timeline_left_container').prop("scrollTop", this.scrollTop)
    $('#compact_view_check_box').change ->
      if this.checked
        $('.cell').addClass('cell_compact')
        $('.date').addClass('date_compact')
        $('.house_code').addClass('house_code_compact')
        $('.job').addClass('job_compact')
        $('.booking_data').hide()
      else
        $('.cell').removeClass('cell_compact')
        $('.date').removeClass('date_compact')
        $('.house_code').removeClass('house_code_compact')
        $('.job').removeClass('job_compact')
        $('.booking_data').show()
    $('.hide_empl_type_jobs').change ->
      job = $("div[data-empl-type-id=#{$(this).data('empl-type-id')}]")
      if this.checked
        job.show()
      else
        job.hide()
    $('.show_job_types').change ->
      job = $("div[data-job-type-id=#{$(this).data('job-type-id')}]")
      if this.checked
        job.show()
      else
        job.hide()
    $('a.hide_house').on 'click', (e) ->
      e.preventDefault()
      house_id = $(this).data('house-id')
      $("div.house_code[data-house-id=#{house_id}]").hide()
      $("div.house_line[data-house-id=#{house_id}]").hide()
      $('#hidden_houses').val($('#hidden_houses').val()+','+house_id)
    $('a#show_all_houses').on 'click', (e) ->
      e.preventDefault()
      $("div.house_code").show()
      $("div.house_line").show()
      $('input[data-group-id]').each ->
        $(this).prop('checked', false)

    $("input[type='checkbox'][data-group-id]").on 'change', ->
      group_id = $(this).data('group-id')
      if this.checked == true
        $("div.house_code[data-house-group-id=#{group_id}]").hide()
        $("div.house_line[data-house-group-id=#{group_id}]").hide()
      if this.checked == false
        $("div.house_code[data-house-group-id=#{group_id}]").show()
        $("div.house_line[data-house-group-id=#{group_id}]").show()

    $.ajax
      url: '/bookings/timeline_data',
      type: "get",
      dataType: "json",
      data: {
        from: $('#from').val(),
        to: $('#to').val(),
        period: $('#period').val(),
        house: $('select#house_number').val()
      },
      success: (data) ->
        console.log('Timeline ready')
        close_dates h for h in data.timeline.houses
        console.log('Bookings and jobs allocated')
      error: (data) ->
        console.log('Something went wrong')

    $(document).on 'click', ->
      $('.dropdown-menu').hide()

    $('.cell').on 'contextmenu', (e) ->
      e.preventDefault()
      $('.dropdown-menu.new_job').hide()
      $('.dropdown-menu.destroy_job').hide()
      posX = e.pageX - $(window).scrollLeft();
      posY = e.pageY - $(window).scrollTop();
      $('.dropdown.new_job').css('top', "#{posY}px")
      $('.dropdown.new_job').css('left', "#{posX}px")
      $('.dropdown').removeClass('dropup')
      $('.dropdown-item.for_booking').attr('data-booking-id', $(this).data('booking-id'))
      $('.dropdown-item').attr('data-house-id', $(this).data('house-id'))
      if posY > $(window).height()/8*5
        $('.dropdown').addClass('dropup')
      if $(this).hasClass('booked')
        $('select#job_booking_id').val($(this).data('booking-id'))
        # $('select#job_house_id').val("")
        $('select#job_house_id').val($(this).data('house-id'))
        $('select#job_house_id').attr('disabled', true)
        $('select#job_booking_id').removeAttr('disabled')
        $('.dropdown_menu_for_booking').show()
      else
        $('select#job_booking_id').val("")
        $('select#job_house_id').val($(this).data('house-id'))
        $('select#job_house_id').removeAttr('disabled')
        $('select#job_booking_id').attr('disabled', true)
        $('.dropdown_menu_for_booking').hide()
      $('input#job_plan').val($(this).data('date'))
      $('input#cell_id').val("##{$(this).attr('id')}")
      $('#new_job div.job_type').hide()
      $('#new_job div.job_user').hide()
      $('#new_job div.job_booking').hide()
      $('#new_job div.job_house').hide()
      $('#new_job div.job_plan').hide()
      $('.dropdown-menu.new_job').toggle()

    $('#new_job_modal').on 'show.bs.modal', (event) ->
      link = $(event.relatedTarget)
      job_type_id = link.data('job-type-id')
      # user_id = link.data('user-id')
      house_id = link.data('house-id')
      booking_id = link.data('booking-id')
      get_employees job_type_id, house_id
      modal = $(this)
      modal.find('#job_time').val('')
      modal.find('#job_job').val('')
      modal.find('#new_job_modal_label').html(link.text())
      modal.find('#new_job #job_details').show()
      modal.find('select#job_job_type_id').val(job_type_id)
      # modal.find('select#job_user_id').val(user_id)
      modal.find('div.job_employee').hide()
      modal.find('select#job_employee_id').html('')
      modal.find('select#job_employee_id').append("<option value=''>Select employee</option>")
      modal.find('input#paid_by_tenant_check_box').prop( "checked", false );

    $('#new_job_modal').on 'shown.bs.modal', (event) ->
      $('input#job_time').trigger('focus')

    $('#new_job').submit (e) ->
      e.preventDefault()
      $.ajax
        beforeSend: (xhr) ->
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        url: '/jobs',
        type: "post",
        dataType: "json",
        data: {
          job: {
            job_type_id: $('select#job_job_type_id').val(),
            # user_id: $('select#job_user_id').val(),
            employee_id: $('select#job_employee_id').val(),
            booking_id:$('select#job_booking_id').val(),
            house_id: $('select#job_house_id').val(),
            job: $('input#job_job').val()
            plan: $('input#job_plan').val(),
            time: $('input#job_time').val(),
            comment: $('input#job_comment').val()
            paid_by_tenant: $('input#paid_by_tenant_check_box').prop('checked')
          },
          cell_id: $('input#cell_id').val()
        },
        success: (data) ->
          console.log('Job created')
          allocate_job data.cell_id, data.job
        error: (data) ->
          console.log('Something went wrong')
          console.log("JSON: #{data.responseJSON}")
          console.log("TEXT: #{data.responseText}")
      $('#new_job_modal').modal('hide')
      return  false;

    $('.cell').on 'contextmenu', '.job', (e) ->
      e.preventDefault()
      $('.dropdown-menu.new_job').hide()
      $('.dropdown-menu.destroy_job').hide()
      posX = e.pageX - $(window).scrollLeft();
      posY = e.pageY - $(window).scrollTop();
      $('.dropdown.destroy_job').css('top', "#{posY}px")
      $('.dropdown.destroy_job').css('left', "#{posX}px")
      $('.dropdown-menu.destroy_job').toggle()
      $('#cancel_job').data('job-id', $(this).data('job-id'))
      e.stopPropagation();

    $('#cancel_job').click (e) ->
      e.preventDefault()
      job_id = $(this).data('job-id')
      $.ajax
        beforeSend: (xhr) ->
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        url: "/jobs/#{job_id}",
        type: "delete",
        dataType: "json",
        success: (data) ->
          $("div[data-job-id='#{job_id}']").remove()
          console.log('Job destroyed')
        error: (data) ->
          console.log('Something went wrong')
      $('.dropdown-menu.new_job').hide()

    # For Bookings form
    if $('#no_check_in_check_box').is(':checked') == true
      $('#booking_check_in').val('')
      $('#booking_check_in').attr('disabled', true)
    if $('#no_check_out_check_box').is(':checked') == true
      $('#booking_check_out').val('')
      $('#booking_check_out').attr('disabled', true)
    $('#no_check_in_check_box').on 'change', ->
      if this.checked == true
        $('#booking_check_in').val('')
        $('#booking_check_in').attr('disabled', true)
      if this.checked == false
        $('#booking_check_in').removeAttr('disabled')
    $('#no_check_out_check_box').on 'change', ->
      if this.checked == true
        $('#booking_check_out').val('')
        $('#booking_check_out').attr('disabled', true)
      if this.checked == false
        $('#booking_check_out').removeAttr('disabled')

    $('[data-toggle="popover"]').popover({container: 'body'})

    $('#get_job_oder').on 'click', (e) ->
      e.preventDefault()
      hidden_groups = []
      $('input[data-group-id]').each ->
        if $(this).is(':checked')
          hidden_groups.push $(this).data('group-id')
      $.ajax
        url: '/jobs/job_order',
        type: "get",
        dataType: "json",
        data: {
          from: $('#from').val(),
          to: $('#to').val(),
          hidden_houses: $('#hidden_houses').val(),
          hidden_groups: hidden_groups,
          house: $('select#house_number').val()
        },
        success: (data) ->
          console.log('Get job order')
          # console.log data.jobs
          $('#ModalJobOrder div.modal-body').html('')
          for i, d of data.jobs
            $('#ModalJobOrder div.modal-body').append("<strong>#{i}</strong><br />")
            for j in d
              $('#ModalJobOrder div.modal-body').append("#{j}<br />")
          $('#ModalJobOrder').modal()
        error: (data) ->
          console.log('Job order - Something went wrong')

    $('input#from').on 'change', (e) ->
      $('input#to').attr('min', $(this).val())

    $('input#to').on 'change', (e) ->
      $('input#from').attr('max', $(this).val())

  # For check in/out
  $('a.edit_comment').on 'click', (e) ->
    e.preventDefault()
    booking_id = $(this).data('booking-id')
    type = $(this).data('type')
    $(".form_edit_comment_gr[data-booking-id=#{booking_id}][data-type=#{type}]").removeClass('d-none')
  $('a.cancel_edit_comment').on 'click', (e) ->
    e.preventDefault()
    booking_id = $(this).data('booking-id')
    $(".form_edit_comment_gr[data-booking-id=#{booking_id}]").addClass('d-none')

  $('#booking_files').on "click", "a[data-link-to-file]", (e) ->
    e.preventDefault()
    url = $(this).data('link-to-file')
    type = $(this).data('file-type')
    if type == 'image'
      media = $('<img></img>', {src: url, width: '100%'})
    else if type == 'pdf'
      media = $('<embed />', {src: "#{url}#toolbar=1&navpanes=0&scrollbar=0", type: "application/pdf", width: '100%', height: '700px'})
    $('div.modal-body').html(media)
    $('#booking_file').modal()
  $('#fileupload_booking').on 'change', (e) ->
    $('#booking_file_name').focus()

  $('#booking_files').on "click", "a[data-print]", (e) ->
    e.preventDefault()
    printJS("https:#{$(this).data('print')}", $(this).data('type'))

  $('#booking_start').on 'change', (e) ->
    $('#booking_finish').attr('min', "#{$(this).val()}")
    check_price()
  $('#booking_finish').on 'change', (e) ->
    $('#booking_start').attr('max', "#{$(this).val()}")
    check_price()
  $('#booking_house_id').on 'change', (e) ->
    check_price()

close_dates = (h) ->
  for b in h.bookings
    for x_add in [0..b.length-1]
      x = b.x+x_add
      $("#x"+x+"y"+b.y).addClass('booked')
      $("#x"+x+"y"+b.y).addClass(b.status)
      $("#x"+x+"y"+b.y).attr('data-booking-id', b.id)
      # $("#x"+x+"y"+b.y).attr('data-toggle', 'tooltip')
      # $("#x"+x+"y"+b.y).attr('data-placement', 'bottom')
      $("#x"+x+"y"+b.y).attr('title', b.details)
      if x_add == 0
        $("#x"+x+"y"+b.y).css("z-index", 3)
        $("#x"+x+"y"+b.y).append("<div class='booking_data'><a href="+b.id+"/edit>"+b.number+"</a></div>")
        if b.startsin == 1
          $("#x"+x+"y"+b.y).addClass('bstart')
    allocate_job "#x#{j.x}y#{b.y}", j for j in b.jobs
  allocate_job "#x#{j.x}y#{h.y}", j for j in h.jobs

allocate_job = (cell, j) ->
  jobs_qty = $(cell).data('jobs')
  jobs_qty = if jobs_qty then jobs_qty else 0
  style = "background-color:"+j.color+";"
  $(cell).append("
    <div  class='job'
          style=#{style}
          data-job-id=#{j.id}
          data-job-type-id=#{j.type_id}
          data-employee-id=#{j.employee_id}
          data-empl-type-id=#{j.empl_type_id}
          title='#{j.job}'
          >
      #{j.code}#{j.time}
    </div>")
  $(cell).data('jobs', jobs_qty+1)

get_employees = (job_type_id, house_id) ->
  $.ajax
    url: '/employees/list_for_job',
    type: "get",
    dataType: "json",
    data: { job_type_id: job_type_id, house_id: house_id },
    success: (data) ->
      # console.log(data)
      $('select#job_employee_id').append("<option value='#{e.id}'>#{e.type} (#{e.name})</option>") for e in data
      if Object.keys(data).length == 1
        $('select#job_employee_id').val(data[0].id)
      if Object.keys(data).length > 1
        $('#new_job div.job_employee').show()
      # console.log 'Employee list loaded'
    error: (data) ->
      console.log('Was not able to read employees list')

check_price = ()->
  start = $('#booking_start').val()
  finish = $('#booking_finish').val()
  house_id = $('#booking_house_id').val()
  if start != '' && finish != '' && house_id != '' &&
  !$('#manual_price_check_box').is(':checked')
    $.ajax
      url: '/bookings/get_price',
      type: "get",
      dataType: "json",
      data: { start: start, finish: finish, house_id: house_id },
      success: (data) ->
        $('#booking_sale').val(data['sale'])
        $('#booking_agent').val(0)
        $('#booking_comm').val(data['comm'])
        $('#booking_nett').val(data['nett'])
        comm_percent = Math.round(parseInt(data['comm'])/parseInt(data['sale'])*100)
        $('#comm_percent').text(comm_percent)
      error: (data) ->
        console.log('Was not able to get price for this period')


