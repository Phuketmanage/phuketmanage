$(document).on 'turbolinks:load', ->
  $ ->
    # submitButton = $('#photoupload').find('input[type="submit"]');
    progressBar  = $('.progress-bar');
    # barContainer = $("<div class='progress'></div>").append(progressBar);
    # $('#photoupload').after(barContainer);

    $('#photoupload').fileupload
      # // fileInput:       fileInput,
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

      start: (e) ->
        # submitButton.prop('disabled', true);
        progressBar.
          # css('background', 'green').
          # css('display', 'block').
          css('width', '0%')
          # text("Loading...");

        # // console.log("start done");
      ,

      done: (e, data) ->
        # submitButton.prop('disabled', false);
        # progressBar.text("Uploading done");

        # // extract key and generate URL from response
        key   = $(data.jqXHR.responseXML).find("Key").text();
        url   = '//' + $('#photoupload').data('host') + '/' + key;

        # // create hidden field
        input = $("<input />", { type:'hidden', name: 'house[photo][]', value: url })
        $('#photoupload').append(input);

        # // console.log("done done");

        $('#photoupload_thumb').fileupload('add', {files: data.files});
        hid = $('input[name=hid]').val()
        $.ajax
          url: "/houses/#{hid}/photos/add",
          type: "get",
          dataType: "json",
          data: {
            photo_url: url
          },
          success: (data) ->
            # console.log('Photo saved')
          error: (data) ->
            console.log('Something went wrong')
      ,

      fail: (e, data) ->
        # submitButton.prop('disabled', false);

        progressBar.
          css("background", "red").
          text("Failed");

        # // console.log(data.messages);


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
      imageQuality: 0.8,
      imageCrop: true,

      submit: (e, data) ->
        data.files[0].name = 'thumb_' + data.files[0].name
      ,

      done: (e, data) ->
        # // extract key and generate URL from response
        key   = $(data.jqXHR.responseXML).find("Key").text();
        url   = '//' + $('#photoupload').data('host') + '/' + key;

        # // var preview_cell = $("</div>")
        preview = " <div class='row' data-photo-id='#{}''>
                        <div class='col-md-2'>
                          <img src=#{url} width='80px', height='80px' />
                        </div>
                        <div class='col-md-5'>

                        </div>
                        <div class='col-md-5'>

                        </div>
                    </div>"
        $('#photo_previews').append(preview)






