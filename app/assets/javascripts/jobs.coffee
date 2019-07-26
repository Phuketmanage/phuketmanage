$(document).on "turbolinks:load", ->
  $('.update_job .form-control').change ->
    job_id = $(this).data('job-id')
    $("#btn_job_#{job_id}").show()
