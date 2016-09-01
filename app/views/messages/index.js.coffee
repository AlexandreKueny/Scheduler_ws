<% if @path %>
$("#messages").append("<%= escape_javascript(render @message) %>")
$("#messages")[0].scrollTop = $("#messages")[0].scrollHeight
<% else %>
$("#unread_badge").html(<%= @unread[:total].to_s %>)
$("<%= "##{@message.chat_room.id} .badge" %>").html(<%= @unread[:chat_room].to_s %>)
<% if @unread[:chat_room] > 0 %>
$("<%= "##{@message.chat_room.id}" %>").addClass("list-group-item-success")
<% end %>
<% end %>