App.messages = App.cable.subscriptions.create "MessagesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if $.inArray($.cookie('current_user'), data.users) >= 0
      $.ajax
        url: '/users/' + $.cookie('current_user') + '/chat_rooms/' + data.chat_room_id + '/messages'
        type: 'get'
        dataType: "json"
        async: false
        success: (response) ->
          reg = RegExp('\/chat_rooms\/' + data.chat_room_id)
          if not window.document.location.pathname.match(reg)
            $('#unread_badge').html(data.unread)
            $('#'+data.chat_room_id + ' .badge').html(data.unread)
            if data.unread > 0
              $('#'+data.chat_room_id).addClass('list-group-item-success')
          else
            $('#messages').append(renderMessage(response))
            $('#messages')[0].scrollTop = $('#messages')[0].scrollHeight
            $.ajax
              url: '/set_unread?chat_room_id=' + data.chat_room_id
              type: 'get'
              async: true

  renderMessage = (data) ->
    '<p id="' + data.id + '" style="word-wrap: break-word"><strong>' + data.user.first_name + ' : </strong>' + data.content + '</p>'