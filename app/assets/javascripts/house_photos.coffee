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
      imageCrop: true,
      imageQuality: 0.8,

      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10);
        progressBar.css('width', progress + '%')
      ,

      start: (e) ->
        progressBar.
          css('width', '0%')
      ,

      done: (e, data) ->
        key   = $(data.jqXHR.responseXML).find("Key").text();

        $('#photoupload_thumb').fileupload('add', {files: data.files} );

        hid = $('input[name=hid]').val()
        $.ajax
          url: "/houses/#{hid}/photos/add",
          type: "get",
          dataType: "json",
          data: {
            photo_url: key
          },
          success: (data) ->
            preview = " <div class='row photo_row mb-1' id='photo_id_#{data.id}' data-file-name='#{data.file_name}'>
                          <div class='col-md-1 photo_thumb'></div>
                          <div class='col-md-5 photo_title_en'></div>
                          <div class='col-md-5 photo_title_en'></div>
                          <div class='col-md-1 photo_title_en'>
                            <a data-confirm='Are you sure?' data-remote='true' rel='nofollow' data-method='delete' href='/photos/#{data.id}'>Delete</a>
                          </div>
                        </div>"
            $('#photo_previews').append(preview)

          error: (data) ->
            console.log('Something went wrong')
      ,

      fail: (e, data) ->
        progressBar.
          css("background", "red").
          text("Failed");



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
      imageMaxWidth: 80,
      imageMaxHeight: 80,

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
        console.log url_parts[1]
        console.log url_parts[2]
        console.log url_parts[1]+url_parts[2]

        # $("div[data-file-name='#{file_name}'] div.photo_thumb").html("<img src='#{url}'' width='80px', height='80px' />")
        $("div[data-file-name='#{file_name}'] div.photo_thumb").html("<a data-fancybox='gallery' href='#{original_url}'><img src='#{url}'></a>")

    $('#photoupload_preview').fileupload
      dropZone:        $('#photoupload_preview'),
      fileInput:       $('#photoupload_preview'),
      url:             $('#photoupload').data('url'),
      type:            'POST',
      autoUpload:       true,
      formData:         $('#photoupload').data('form-data'),
      paramName:        'file', #// S3 does not like nested name fields i.e. name="user[avatar_url]"
      dataType:         'XML',  #// S3 returns XML if success_action_status is set to 201
      disableImageResize: false,
      imageMaxWidth: 250,
      imageMaxHeight: 250,
      imageQuality: 0.8,
      imageCrop: true,

      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10);
        progressBar_preview.css('width', progress + '%')
      ,

      start: (e) ->
        progressBar_preview.
          css('width', '0%')
      ,

      submit: (e, data) ->
        data.files[0].name = 'preview_' + data.files[0].name
      ,

      done: (e, data) ->
        key   = $(data.jqXHR.responseXML).find("Key").text();
        url   = '//' + $('#photoupload').data('host') + '/' + key;

        hid = $('input[name=hid]').val()
        $.ajax
          url: "/houses/#{hid}/photos/add",
          type: "get",
          dataType: "json",
          data: {
            photo_url: key,
            preview: true
          },
          success: (data) ->
            preview = " <div class='row photo_row mb-1' id='photo_id_#{data.id}' data-file-name='#{data.file_name}'>
                          <div class='col-md-1 photo_thumb'></div>
                          <div class='col-md-5 photo_title_en'></div>
                          <div class='col-md-5 photo_title_en'></div>
                          <div class='col-md-1 photo_title_en'>
                            <a data-confirm='Are you sure?' data-remote='true' rel='nofollow' data-method='delete' href='/photos/#{data.id}'>Delete</a>
                          </div>
                        </div>"
            # preview = "<img src='#{url}'>"
            $('#house_preview').html("<img src='#{url}'>")

          error: (data) ->
            console.log('Something went wrong')
      ,

      fail: (e, data) ->
        progressBar_preview.
          css("background", "red").
          text("Failed");

        # // console.log(data.messages);
