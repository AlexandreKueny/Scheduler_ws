jQuery ->
  $('.clickable-row').click ->
    window.document.location = $(this).data('href')

  $('.edit').editable ((value, settings) ->
    $.ajax
      url: window.document.location + '?name=' + value
      type: 'patch'
      async: true
    return value
  )

  $('#chat_input').keypress (e) ->
    if e.which == 13
      $.ajax
        url: window.document.location + '/messages?chat_room_id=' + chat_id() + '&content=' + $('#chat_input').val()
        type: 'post'
        async: true
      e.target.value = ''
      
  $('#start-chat-btn').click ->
    $.ajax
      url: window.document.location + '/chat_rooms'
      type: 'post'
      dataType: "json"
      success: (data) ->
        console.log data
        window.location = data.url
#        document.open();
#        document.write(data)
#        document.close();

  chat_id = ->
    $('.infos').data('id')