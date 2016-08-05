jQuery ->

  if $('#messages').size() > 0
    $('#messages')[0].scrollTop = $('#messages')[0].scrollHeight

  $('.edit').editable ((value, settings) ->
    $.ajax
      url: window.document.location + '?name=' + value
      type: 'patch'
      async: true
    return value
  )

  removed = []
  hidden = []

  $('#dismiss-modal').click ->
    $('#users-modal').modal('hide')
    $.each hidden, (i, e) ->
      e.show()
    hidden = []
    removed = []

  $('#validate-modal').click ->
    $.ajax
      type: 'patch'
      url: window.document.location.pathname
      data: {removed: removed.toString()}
      dataType: 'json'
    $('#users-modal').modal('hide')


  $('.remove-user').on 'click', ->
    elem = $(this).parent()
    hidden.push elem
    removed.push elem.data('id')
    elem.hide()
    console.log removed

  $('textarea#message_content').keypress (e) ->
    if e.which == 13
      if not e.shiftKey
        $('[data-textarea="message"]').val($('[data-textarea="message"]').val().split('\n').join('<br>'))
        $('[data-send="message"]').click()
        $('[data-textarea="message"]').val('')

  $('#start-chat-btn').click ->
    $.ajax
      url: window.document.location + '/chat_rooms'
      type: 'post'
      dataType: "json"
      success: (data) ->
        console.log data
        window.location = data.url