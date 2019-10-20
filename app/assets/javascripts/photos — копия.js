// $(document).on('turbolinks:load', function() {
//   $(function() {
//     var submitButton = $('#photoupload').find('input[type="submit"]');
//     var progressBar  = $("<div class='bar'></div>");
//     var barContainer = $("<div class='progress'></div>").append(progressBar);
//     $('#photoupload').after(barContainer);

//     $('#photoupload').fileupload({
//       // fileInput:       fileInput,
//       url:             $('#photoupload').data('url'),
//       type:            'POST',
//       autoUpload:       true,
//       formData:         $('#photoupload').data('form-data'),
//       paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
//       dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
//       disableImageResize: false,
//       imageMaxWidth: 2500,
//       imageMaxHeight: 2500,

//       progressall: function (e, data) {
//         var progress = parseInt(data.loaded / data.total * 100, 10);
//         progressBar.css('width', progress + '%')
//       },

//       start: function (e) {
//         submitButton.prop('disabled', true);
//         progressBar.
//           css('background', 'green').
//           css('display', 'block').
//           css('width', '0%').
//           text("Loading...");

//         // console.log("start done");
//       },

//       done: function(e, data) {
//         submitButton.prop('disabled', false);
//         progressBar.text("Uploading done");

//         // extract key and generate URL from response
//         var key   = $(data.jqXHR.responseXML).find("Key").text();
//         var url   = '//' + $('#photoupload').data('host') + '/' + key;

//         // create hidden field
//         var input = $("<input />", { type:'hidden', name: 'house[photo][]', value: url })
//         $('#photoupload').append(input);

//         // console.log("done done");

//         $('#photoupload_thumb').fileupload('add', {files: data.files});
//         // $.ajax
//         //   url: '/bookings/timeline_data',
//         //   type: "get",
//         //   dataType: "json",
//         //   data: {
//         //     from: $('#from').val(),
//         //     to: $('#to').val(),
//         //     period: $('#period').val()
//         //   },
//         //   success: (data) ->
//         //     console.log('Timeline ready')
//         //     close_dates h for h in data.timeline.houses
//         //     console.log('Bookings and jobs allocated')
//         //   error: (data) ->
//         //     console.log('Something went wrong')

//       },

//       fail: function(e, data) {
//         submitButton.prop('disabled', false);

//         progressBar.
//           css("background", "red").
//           text("Failed");

//         // console.log(data.messages);
//       }
//     });

//     $('#photoupload_thumb').fileupload({
//       dropZone:        null,
//       fileInput:       $('#photoupload_thumb'),
//       url:             $('#photoupload').data('url'),
//       type:            'POST',
//       autoUpload:       true,
//       formData:         $('#photoupload').data('form-data'),
//       paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
//       dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
//       disableImageResize: false,
//       imageMaxWidth: 80,
//       imageMaxHeight: 80,
//       imageQuality: 0.8,
//       imageCrop: true,

//       submit: function(e, data) {
//         data.files[0].name = 'thumb_' + data.files[0].name
//       },

//       done: function(e, data) {
//         // extract key and generate URL from response
//         var key   = $(data.jqXHR.responseXML).find("Key").text();
//         var url   = '//' + $('#photoupload').data('host') + '/' + key;

//         // var preview_cell = $("</div>")
//         var preview = $("<img />", {src: url, width:80, height: 80, class: 'mr-1'})
//         $('#photo_previews').append(preview)

//       }
//     });
//   });
// });


