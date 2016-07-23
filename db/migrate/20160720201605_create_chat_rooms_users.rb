class CreateChatRoomsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_rooms_users do |t|
      t.uuid :chat_room_id
      t.uuid :user_id
    end
  end
end
