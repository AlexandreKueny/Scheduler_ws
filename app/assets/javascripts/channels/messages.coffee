App.messages = App.cable.subscriptions.create "MessagesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#messages').append(renderMessage(data))
    reg = RegExp('\/chat_rooms\/' + data.chat_room_id)
    if not window.document.location.pathname.match(reg)
      $('#unread_badge').html(data.unread)
      $('#'+data.chat_room_id + ' .badge').html(data.unread)
      if data.unread > 0
        $('#'+data.chat_room_id).addClass('success')
    else
      $.ajax
        url: '/set_unread?chat_room_id=' + data.chat_room_id
        type: 'get'
        async: true

  renderMessage = (data) ->
    "<p>" + data.user + " / " + data.message + "</p>"