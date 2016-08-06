jQuery ->

  Array::diff = (a) ->
    @filter (i) ->
      a.indexOf(i) < 0

  if $('#messages').size() > 0
    $('#messages')[0].scrollTop = $('#messages')[0].scrollHeight

  $('.edit').editable ((value, settings) ->
    $.ajax
      url: window.document.location + '?name=' + value
      type: 'patch'
      async: true
    return value
  )

  added= []
  removed = []
  hidden = []

  $('#add-user')
  .typeahead {highlight: false},
    name: 'names',
    display: 'name'
    source: (query, syncResults, asyncResults) ->
      $.get '/users.json?search=' + query, (data) ->
        asyncResults data
  .on 'typeahead:selected', ($e, datum) ->
    exist = false
    $.each $('#users-list .user-line'), (i, e) ->
      if $(e).data('id') == datum.id
        exist = true
    if exist
      $.each removed, (i, e) ->
        if e == datum.id
          exist = false
    if not exist
      $('#users-list').append(renderUser(datum))
      added.push datum.id
      $('#error-text').hide()
  .on 'typeahead:close', ->
    $(this).val('')
  .on 'typeahead:idle', ->
    $(this).val('')

  $('#dismiss-modal').click ->
    $('#users-modal').modal('hide')
    $('#error-text').hide()
    $.each hidden, (i, e) ->
      e.show()
    $('[data-new=true]').remove()
    hidden = []
    removed = []
    added = []

  $('#validate-modal').click ->
    console.log added
    console.log removed
    $.ajax
      type: 'patch'
      url: window.document.location.pathname
      data: {removed: JSON.stringify(removed), added: JSON.stringify(added)}
      dataType: 'json'
    $('#users-modal').modal('hide')
    $('#error-text').hide()
    $.each hidden, (i, e) ->
      e.remove()
    hidden = []
    removed = []
    added = []

  $('#validate-new-chat-room-modal').click ->
    console.log added
    console.log removed
    $.ajax
      type: 'get'
      url: window.document.location.pathname + '/new'
      data: {users: JSON.stringify(added.diff(removed))}
      dataType: 'json'
      success: (data) ->
        window.document.location = data.href
    $('#users-modal').modal('hide')
    $('#error-text').hide()
    $.each hidden, (i, e) ->
      e.remove()
    hidden = []
    removed = []
    added = []


  $('#users-list').on 'click', '.remove-user', ->
    if removed.length + 1 < $('#users-list .user-line').size()
      elem = $(this).parent()
      hidden.push elem
      removed.push elem.data('id')
      elem.hide()
    else
      $('#error-text').show()

  $('textarea#message_content').keypress (e) ->
    if e.which == 13
      if not e.shiftKey
        $('[data-textarea="message"]').val($('[data-textarea="message"]').val().split('\n').join('<br>'))
        e.preventDefault()
        $('[data-send="message"]').click()
        $('#message_content').val('')


  $('#start-chat-btn').click ->
    $.ajax
      url: window.document.location + '/chat_rooms'
      type: 'post'
      dataType: "json"
      success: (data) ->
        console.log data
        window.location = data.url

  renderUser = (data) ->
    '<li class="list-group-item user-line" data-id="' + data.id + '" data-new="true">' +
      data.name +
      '<button class="btn btn-danger pull-right remove-user">
        <span class="glyphicon glyphicon-remove"></span>
      </button>
    </li>'