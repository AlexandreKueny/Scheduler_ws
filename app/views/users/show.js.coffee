$('#users-list').append("<%= escape_javascript(render partial: 'chat_rooms/user-modal', locals: {user: @user}) %>")
$('#error-text').hide()