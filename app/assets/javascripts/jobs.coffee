$(document).on "turbolinks:load", ->
  $('.update_job .form-control').change ->
    job_id = $(this).data('job-id')
    $("#btn_job_#{job_id}").show()

  $('a#edit_plan').on 'click', (e) ->
    e.preventDefault()
    job_id = $(this).data('job-id')
    if $(this).text() == 'Edit'
      $("#form_edit_plan_#{job_id}").show()
      $(this).text('Cancel edit')
    else
      $("#form_edit_plan_#{job_id}").hide()
      $(this).text('Edit')


  $('a#edit_job').on 'click', (e) ->
    e.preventDefault()
    job_id = $(this).data('job-id')
    if $(this).text() == 'Edit'
      $("#form_edit_job_#{job_id}").show()
      $(this).text('Cancel edit')
    else
      $("#form_edit_job_#{job_id}").hide()
      $(this).text('Edit')

  $('a#edit_comment').on 'click', (e) ->
    e.preventDefault()
    job_id = $(this).data('job-id')
    if $(this).text() == 'Edit'
      $("#form_edit_comment_#{job_id}").show()
      $(this).text('Cancel edit')
    else
      $("#form_edit_comment_#{job_id}").hide()
      $(this).text('Edit')
