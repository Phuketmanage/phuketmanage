$(document).on "ready", ->
  $('.update_todo .form-control').change ->
    todo_id = $(this).data('todo-id')
    $("#btn_todo_#{todo_id}").show()
