class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.uuid :chat_room_id
      t.uuid :user_id

      t.string :content

      t.timestamps

      t.index ["chat_room_id"], name: "index_messages_on_chat_room_id"
      t.index ["user_id"], name: "index_messages_on_user_id"
    end
  end
end
