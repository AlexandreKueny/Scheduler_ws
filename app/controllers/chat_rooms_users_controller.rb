class ChatRoomsUsersController < ApplicationController
  before_action :authenticate_user!

  def set_unread
    ChatRoomsUser.where(user_id: current_user.id, chat_room_id: params[:chat_room_id]).take.update(unread: 0)
    head :ok
  end

end
