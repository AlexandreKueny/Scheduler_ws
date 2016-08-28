jQuery ->

  format = 'DD/MM/YYYY HH:mm'
  
  datetimepicker = () ->
    $('#datetimepicker1').datetimepicker(
        locale: 'fr'
        calendarWeeks: true
        showTodayButton: false
        stepping: 5
    )
  
    $('#datetimepicker2').datetimepicker(
      locale: 'fr'
      calendarWeeks: true
      showTodayButton: false
      stepping: 5
    )

  $('#datetimepicker1').on("dp.change", (e) ->
    $('#datetimepicker2').data('DateTimePicker').date(e.date.add(1, 'hour'))
  )

  $('#allDay-checkbox').change ->
    if $(this).is(':checked')
      $('#datetimepicker1').data('DateTimePicker').format('DD/MM/YYYY')
      $('#datetimepicker2').data('DateTimePicker').format('DD/MM/YYYY')
    else
      $('#datetimepicker1').data('DateTimePicker').format(format)
      $('#datetimepicker2').data('DateTimePicker').format(format)

  $('#remote').on 'click', '#validate-event-btn', ->
    $('#submit-event').click()
    $('.modal').modal('hide')

  updateEvent = (event) ->
    if event.end
      end = event.end
    else
      end = moment(event.start).add(2, 'hour')
    $.ajax
      url: event.update_url
      data:
        event:
          id: event.id
          start: event.start.format()
          end: end.format()
          allDay: event.allDay
      method: 'PATCH'

  $('#calendar').fullCalendar(
    events: '/users/' + $.cookie('current_user') + '/events.json'
    lang: 'fr'
    header:
      left: 'prev,next today newEventButton'
      center: 'title'
      right: 'agendaDay,agendaWeek,month'
    editable: true
    eventLimit: true
    weekNumbers: true
    selectable: true
    selectHelper: true
    customButtons:
      newEventButton:
        text: 'New Event'
        click: ->
          $.getScript('/users/' + $.cookie('current_user') + '/events/new', ->
            datetimepicker()
            $('#datetimepicker1').data('DateTimePicker').date(moment().add( 5 - (moment().minute() % 5), 'minutes'))
            $('#datetimepicker2').data('DateTimePicker').date(moment().add( 5 - (moment().minute() % 5), 'minutes').add(1, 'hours'))
          )
    eventDrop: (event, delta, revertFunc) ->
      updateEvent(event)
    eventResize: (event) ->
      updateEvent(event)
    eventClick: (event, jsEvent, view) ->
      $.getScript(event.edit_url, ->
        datetimepicker()
        $('#datetimepicker1').data('DateTimePicker').date(event.start)
        $('#datetimepicker2').data('DateTimePicker').date(event.end)
      )
      return view

    select: (eventStart, eventEnd) ->
      start = moment(eventStart)
      end = moment(eventEnd)
      $.getScript('/users/' + $.cookie('current_user') + '/events/new', ->
        datetimepicker()
        if start.add(end.dayOfYear() - start.dayOfYear(), 'day').format(format) == end.format(format)
          $('#allDay-checkbox').prop('checked', true)
          $('#datetimepicker1').data('DateTimePicker').format('DD/MM/YYYY')
          $('#datetimepicker2').data('DateTimePicker').format('DD/MM/YYYY')
        else
          $('#allDay-checkbox').prop('checked', false)
          $('#datetimepicker1').data('DateTimePicker').format(format)
          $('#datetimepicker2').data('DateTimePicker').format(format)
        $('#datetimepicker1').data('DateTimePicker').date(eventStart)
        $('#datetimepicker2').data('DateTimePicker').date(eventEnd)
      )
  )