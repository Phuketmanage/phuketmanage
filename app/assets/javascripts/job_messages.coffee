$(document).on "turbolinks:load", ->
  if objDiv = document.getElementById("job_messages")
    objDiv.scrollTop = objDiv.scrollHeight

  fileInput = $('#fileupload_msg')
  if fileInput.length > 0
    form = $(fileInput.parents('form:first'))
    submitButton = form.find('button[type="submit"]')
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
        formData.set('Content-Type', file.type)
        newname = "#{(new Date).getTime()} #{file.name}"
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
            loaded += file.size
            key   = $(data).find('Key').text()
            job_id = $('input[name=job_id]').val()

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
            submitButton.prop('disabled', false)
            progressBar.hide()
            progressBar.css('width', '0%')
          fail: (data) ->
            console.log data.jqXHR.responseText


  # $ ->
  #   progressBar  = $('.progress-bar.thumb');
  #   progressBar_preview  = $('.progress-bar.preview');
  #   $('#fileupload_message').fileupload
  #     # // fileInput:       fileInput,
  #     dropZone:        $('#fileupload_message'),
  #     url:             $('#fileupload_message').data('url'),
  #     type:            'POST',
  #     autoUpload:       true,
  #     formData:         $('#fileupload_message').data('form-data'),
  #     paramName:        'file', #// S3 does not like nested name fields i.e. name="user[avatar_url]"
  #     dataType:         'XML',  #// S3 returns XML if success_action_status is set to 201
  #     disableImageResize: true,
  #     # imageMaxWidth: 2500,
  #     # imageMaxHeight: 2500,

  #     progressall: (e, data) ->
  #       progress = parseInt(data.loaded / data.total * 100, 10);
  #       progressBar.css('width', progress + '%')
  #     ,
  #     processstart: (e) ->
  #       $('#alert_photos').remove()
  #     ,
  #     processfail: (e, data) ->
  #       if $('#alert_photos').length == 0
  #         progressBar.parent().after $('<div class="alert alert-warning mt-2" role="alert" id="alert_photos"></div>')
  #       $('#alert_photos').append("<p>#{data.files[data.index].name} - #{data.files[data.index].error}</p>")
  #     ,
  #     start: (e) ->
  #       progressBar.css('width', '0%')
  #     ,

  #     done: (e, data) ->
  #       key   = $(data.jqXHR.responseXML).find("Key").text();
  #       job_id = $('input[name=job_id]').val()
  #       files = data.files

  #       $.ajax
  #         url: "/job_messages",
  #         type: "post",
  #         dataType: "script",
  #         data: {
  #           job_message: {
  #             message: key,
  #             file: 1
  #           },
  #           job_id: job_id
  #         }
  #       progressBar.css('width', '0%')
  #     ,

  #     fail: (e, data) ->
  #       progressBar.
  #         css("background", "red")

  $("a[data-link-to-image]").on "click", (e) ->
    e.preventDefault()
    url = $(this).attr('href')
    $('div.modal-body').html("<img src='#{url}' width='100%'>")
    $('#message_image').modal()
