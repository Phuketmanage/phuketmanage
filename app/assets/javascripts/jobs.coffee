$(document).on "ready", ->
  $('.update_job .form-control').change ->
    job_id = $(this).data('job-id')
    $("#btn_job_#{job_id}").show()

  # $('a.open_job_chat').on 'click', (e) ->
  #   e.preventDefault()
  #   job_id = $(this).data('job-id')
  #   prev_job_id = $("#job_messages").data('job-id')
  #   $(this).text('Active')
  #   $("div#job_#{job_id}").removeClass("bg-white")
  #   $("div#job_#{job_id}").addClass("bg-light")
  #   $("a.open_job_chat[data-job-id=#{prev_job_id}]").text('Open')
  #   $("div#job_#{prev_job_id}").removeClass("bg-light")
  #   $("div#job_#{prev_job_id}").addClass("bg-white")
  #   $("#job_messages").data("job-id", job_id)
  #   $("#job_messages").html(job_id)


  $('a#edit_job').on 'click', (e) ->
    e.preventDefault()
    job_id = $(this).data('job-id')
    if $(this).text() == 'Edit'
      $("#form_edit_job_#{job_id}").show()
      $(this).text('Cancel edit')
    else
      $("#form_edit_job_#{job_id}").hide()
      $(this).text('Edit')

