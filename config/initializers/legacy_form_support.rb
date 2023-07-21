# Adds data: { remote: true } to all generated forms (default setting before Rails 6). Used by old forms submiting JS.
#
# TODO: #268 Mail to manager about new booking - link should open list with bookings for house

Rails.application.config.action_view.form_with_generates_remote_forms = true
