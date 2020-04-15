$(document).on "turbolinks:load", ->
  objDiv = document.getElementById("job_messages")
  objDiv.scrollTop = objDiv.scrollHeight;
  $ ->
    progressBar  = $('.progress-bar.thumb');
    progressBar_preview  = $('.progress-bar.preview');
    $('#fileupload_message').fileupload
      # // fileInput:       fileInput,
      dropZone:        $('#fileupload_message'),
      url:             $('#fileupload_message').data('url'),
      type:            'POST',
      autoUpload:       true,
      formData:         $('#fileupload_message').data('form-data'),
      paramName:        'file', #// S3 does not like nested name fields i.e. name="user[avatar_url]"
      dataType:         'XML',  #// S3 returns XML if success_action_status is set to 201
      disableImageResize: true,
      # imageMaxWidth: 2500,
      # imageMaxHeight: 2500,

      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10);
        progressBar.css('width', progress + '%')
      ,
      processstart: (e) ->
        $('#alert_photos').remove()
      ,
      processfail: (e, data) ->
        if $('#alert_photos').length == 0
          progressBar.parent().after $('<div class="alert alert-warning mt-2" role="alert" id="alert_photos"></div>')
        $('#alert_photos').append("<p>#{data.files[data.index].name} - #{data.files[data.index].error}</p>")
      ,
      start: (e) ->
        progressBar.css('width', '0%')
      ,

      done: (e, data) ->
        key   = $(data.jqXHR.responseXML).find("Key").text();
        job_id = $('input[name=job_id]').val()
        files = data.files

        $.ajax
          url: "/job_messages",
          type: "post",
          dataType: "script",
          data: {
            job_message: {
              message: key,
              file: 1
            },
            job_id: job_id
          }
        progressBar.css('width', '0%')
      ,

      fail: (e, data) ->
        progressBar.
          css("background", "red")
  $("a[data-link-to-image]").on "click", (e) ->
    e.preventDefault()
    url = $(this).attr('href')
    $('div.modal-body').html("<img src='#{url}' width='100%'>")
    $('#message_image').modal()
