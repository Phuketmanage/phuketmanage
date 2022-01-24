$(document).on "turbolinks:load", ->
  # download file
  $('a[data-download-file]').on "click", (e) ->
    e.preventDefault()
    $.ajax
      url: "/transaction_file_download",
      type: "get",
      dataType: "json",
      data: {
        key: $(this).data('download-file')
      },
      success: (data) ->
        alert('Success')
      fail: (data) ->
        console.log 'Can not download file'
