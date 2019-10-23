$(document).on 'turbolinks:load', ->
  $ ->
    progressBar  = $('.progress-bar.thumb');
    progressBar_preview  = $('.progress-bar.preview');
    $('#photoupload').fileupload
      # // fileInput:       fileInput,
      dropZone:        $('#photoupload'),
      url:             $('#photoupload').data('url'),
      type:            'POST',
      autoUpload:       true,
      formData:         $('#photoupload').data('form-data'),
      paramName:        'file', #// S3 does not like nested name fields i.e. name="user[avatar_url]"
      dataType:         'XML',  #// S3 returns XML if success_action_status is set to 201
      disableImageResize: false,
      imageMaxWidth: 2500,
      imageMaxHeight: 2500,

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
        hid = $('input[name=hid]').val()
        files = data.files

        $.ajax
          url: "/houses/#{hid}/photos/add",
          type: "get",
          dataType: "json",
          data: {
            photo_url: key
          },
          success: (data) ->
            if data.status != 'duplicate'
              authenticity_token = $("input[name='authenticity_token']").val()
              preview = "
                          <form class='update_photo' action='/house_photos/#{data.id}' accept-charset='UTF-8' data-remote='true' method='post' id='form_edit_photo_id_#{data.id}'>
                            <input name='utf8' type='hidden' value='✓'>
                            <input type='hidden' name='_method' value='patch'>
                            <input type='hidden' name='authenticity_token' value='#{authenticity_token}'>
                            <div class='row photo_row mb-3' id='photo_id_#{data.id}''>
                              <div class='col-md-2 photo_thumb' data-file-name='#{data.file_name}'></div>
                              <div class='col-md-8 photo_titles'>
                                <input placeholder='Title' class='form-control mb-1 photo_title_input' type='text' name='house_photo[title_en]'' id='house_photo_title_en' data-photo-id='#{data.id}'>
                                <input placeholder='Подпись' class='form-control mb-1 photo_title_input' type='text' name='house_photo[title_ru]'' id='house_photo_title_ru' data-photo-id='#{data.id}'>
                              </div>
                              <div class='col-md-2 photo_actions text-right'>
                                <input type='submit' name='commit' value='Update' class='btn btn-primary btn-sm btn-block' data-disable-with='Updating...''>
                                <input type='submit' name='commit' value='Use as default' class='btn btn-success btn-sm btn-block mt-md-1'>
                                <a data-confirm='Are you sure?' class='btn btn-danger btn-sm btn-block mt-md-1' role='button' data-remote='true' rel='nofollow' data-method='delete' href='/house_photos/#{data.id}'>Delete</a>
                              </div>
                            </div>
                          </form>"
              $('#photo_previews').append(preview)
          error: (data) ->
            console.log('Something went wrong')
        .done (data) ->
          if data.status != 'duplicate'
            $('#photoupload_thumb').fileupload('add', {files: files} );
      ,

      fail: (e, data) ->
        progressBar.
          css("background", "red")

    $('#photoupload_thumb').fileupload
      dropZone:        null,
      fileInput:       $('#photoupload_thumb'),
      url:             $('#photoupload').data('url'),
      type:            'POST',
      autoUpload:       true,
      formData:         $('#photoupload').data('form-data'),
      paramName:        'file', #// S3 does not like nested name fields i.e. name="user[avatar_url]"
      dataType:         'XML',  #// S3 returns XML if success_action_status is set to 201
      disableImageResize: false,
      imageMaxWidth: 450,
      imageMaxHeight: 450,

      submit: (e, data) ->
        data.files[0].name = 'thumb_' + data.files[0].name
      ,

      done: (e, data) ->
        # // extract key and generate URL from response
        key   = $(data.jqXHR.responseXML).find("Key").text();
        url   = '//' + $('#photoupload').data('host') + '/' + key;

        regex = /(^.*[\/])thumb_(.*)$/i
        url_parts = regex.exec(url)
        file_name = url_parts[2]
        original_url = url_parts[1]+url_parts[2]
        # Set first image as preview if no preview yet
        console.log $('#house_preview_img').length
        if $('#house_preview_img').length  == 0
          url   = '//' + $('#photoupload').data('host') + '/' + key;
          console.log url
          $('#house_preview').append("<img src='#{url}' class='img-fluid' id='house_preview_img'>")

        $("div.photo_thumb[data-file-name='#{file_name}']").append("<img src='#{url}' class='img-fluid'>")

    # $('#photoupload_preview').fileupload
    #   dropZone:        $('#photoupload_preview'),
    #   fileInput:       $('#photoupload_preview'),
    #   url:             $('#photoupload').data('url'),
    #   type:            'POST',
    #   autoUpload:       true,
    #   formData:         $('#photoupload').data('form-data'),
    #   paramName:        'file', #// S3 does not like nested name fields i.e. name="user[avatar_url]"
    #   dataType:         'XML',  #// S3 returns XML if success_action_status is set to 201
    #   # imageForceResize: true,
    #   # disableImageResize: false,
    #   # imageMaxWidth: 360,
    #   # imageMaxHeight: 360,
    #   # imageQuality: 0.9,
    #   # imageCrop: true,
    #   processQueue: [
    #     {
    #       action: 'loadImage',
    #     },
    #     {
    #       action: 'validate',
    #       maxFileSize: 10000000,
    #       acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
    #     },
    #     {
    #       action: 'resizeImage',
    #       # maxWidth: 360,
    #       # maxHeight: 360,
    #       # crop: true
    #     },
    #     { action: 'saveImage' },
    #   ],
    #   progressall: (e, data) ->
    #     progress = parseInt(data.loaded / data.total * 100, 10);
    #     progressBar_preview.css('width', progress + '%')
    #   ,
    #   processfail: (e, data) ->
    #     alert = $('<div class="alert alert-warning mt-2" role="alert" id="alert_preview"></div>')
    #     all_alerts = alert.append("<p>#{data.files[data.index].name} - #{data.files[data.index].error}</p>")
    #     progressBar_preview.parent().after all_alerts
    #   ,
    #   start: (e) ->
    #     progressBar_preview.
    #       css('width', '0%')
    #   ,

    #   submit: (e, data) ->
    #     data.files[0].name = 'preview_' + data.files[0].name
    #   ,

    #   done: (e, data) ->
    #     key   = $(data.jqXHR.responseXML).find("Key").text();
    #     url   = '//' + $('#photoupload').data('host') + '/' + key;
    #     hid = $('input[name=hid]').val()
    #     $.ajax
    #       url: "/houses/#{hid}/photos/add",
    #       type: "get",
    #       dataType: "json",
    #       data: {
    #         photo_url: key,
    #         preview: true
    #       },
    #       success: (data) ->
    #         $('#house_preview').html("<img src='#{url}' class='img-fluid'>")

    #       error: (data) ->
    #         console.log('Something went wrong')
    #   ,

    #   fail: (e, data) ->
    #     progressBar_preview.
    #       css("background", "red")
  $('#photo_previews').on 'change', 'form input.photo_title_input', ->
    photo_id = $(this).data('photo-id')
    form = document.querySelector("#form_edit_photo_id_#{photo_id}");
    Rails.fire(form, 'submit');

  lightGallery document.getElementById('lightgallery'),
    download: false

  $(".house_main_photo_parent").on "click", (e) ->
    e.preventDefault()
    $("#lightgallery a:first-child > img").trigger("click");
