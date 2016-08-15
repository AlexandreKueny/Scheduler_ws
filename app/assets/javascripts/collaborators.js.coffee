jQuery ->

  respond_to_request = (id, action) ->
    $.post('/users/' + $.cookie('current_user') + '/collaborators/respond', {collaborators_link_id: id, decision: action})
  
  $('.accept-request').click ->
    respond_to_request($(this).data('id'), 'accept')
    $('#requests-modal').modal('hide')

  $('.decline-request').click ->
    respond_to_request($(this).data('id'), 'decline')
    $('#requests-modal').modal('hide')


  $('#add-collaborator-btn').click ->
    $.get(window.document.location.pathname + '/collaborators/new')
    $('#added-collaborator-btn').get(0).style.display = 'block'
    $(this).get(0).style.display = 'none'

  $('#remove-collaborator-btn').click ->
    $.get(window.location.pathname + '/collaborators/remove')
    $('#added-collaborator-btn').get(0).style.display = 'none'
    $('#add-collaborator-btn').get(0).style.display = 'block'