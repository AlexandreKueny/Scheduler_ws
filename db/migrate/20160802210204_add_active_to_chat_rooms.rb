class AddActiveToChatRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :chat_rooms, :active, :boolean, default: :false
  end
end
