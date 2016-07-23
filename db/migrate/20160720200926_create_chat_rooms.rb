class CreateChatRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_rooms, id: :uuid do |t|
      t.string :name, default: 'ChatRoom'

      t.timestamps
    end
  end
end
