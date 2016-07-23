$ ->
  $('#searchBar')
  .typeahead {highlight: false},
    name: 'names',
    display: 'name'
    source: (query, syncResults, asyncResults) ->
      $.get '/users.json?search=' + query, (data) ->
        asyncResults data
  .on 'typeahead:selected', ($e, datum) ->
    window.location.href = '/users/' + datum.id
  .keypress (event) ->
    if event.which == 13
      window.location.href = '/users?search=' + $(this).val()

  $('.twitter-typeahead').on('mouseenter', '.tt-suggestion', (e) ->
    $('.tt-cursor', $(this).closest('.tt-menu')).removeClass 'tt-cursor'
    $(this).addClass 'tt-cursor'
  ).on 'mouseleave', '.tt-menu', (e) ->
    $('.tt-cursor', $(this).closest('.tt-menu')).removeClas