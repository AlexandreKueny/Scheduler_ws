json.id event.id
json.title event.title
json.description event.description
json.allDay event.allDay
json.url event.url
json.startEditable event.startEditable
json.durationEditable event.durationEditable
json.overlap event.overlap
json.color event.color
json.start event.start
json.end event.end
json.update_url user_event_path(current_user, event, method: :patch)
json.edit_url edit_user_event_path(current_user, event)