jQuery ->

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

  $('#calendar').fullCalendar(
    events: '/users/' + $.cookie('current_user') + '/events.json'
    lang: 'en'
    header:
      left: 'prev,next today newEventButton'
      center: 'title'
      right: 'agendaDay,agendaWeek,month'
    editable: true
    eventLimit: true
    weekNumbers: true
    customButtons:
      newEventButton:
        text: 'New Event'
        click: ->
          $('#new-event-modal').modal('show')
          $('#datetimepicker1').data('DateTimePicker').date(moment().add( 5 - (moment().minute() % 5), 'minutes'))
          $('#datetimepicker2').data('DateTimePicker').date(moment().add( 5 - (moment().minute() % 5), 'minutes').add(1, 'hours'))
  )