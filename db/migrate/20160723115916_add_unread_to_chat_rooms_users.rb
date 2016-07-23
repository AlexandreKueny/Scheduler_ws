class AddUnreadToChatRoomsUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :chat_rooms_users, :unread, :integer, default: nil
  end
end
