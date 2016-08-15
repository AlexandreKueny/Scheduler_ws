json.array! @events do |event|
  json.extract event, :id, :title, :description, :allDay, :url, :editable, :startEditable, :durationEditable, :overlap, :color
  json.start event.start.getlocal
  json.end event.end.getlocal
end