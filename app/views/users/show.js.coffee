$('#users-list').append("<%= escape_javascript(render partial: 'chat_rooms/user-line', locals: {user: @user}) %>")
$('#error-text').hide()