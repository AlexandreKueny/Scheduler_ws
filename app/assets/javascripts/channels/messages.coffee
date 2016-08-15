App.messages = App.cable.subscriptions.create "MessagesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if $.inArray($.cookie('current_user'), data.users) >= 0
      $.ajax
        url: '/users/' + $.cookie('current_user') + '/chat_rooms/' + data.chat_room_id + '/messages'
        data: {url: window.location.pathname}
        type: 'get'
        dataType: "script"
        