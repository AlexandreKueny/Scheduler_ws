class AddColumnRemovedToChatRoomsUser < ActiveRecord::Migration[5.0]
  def change
    add_column :chat_rooms_users, :deleted, :boolean, default: false
  end
end
