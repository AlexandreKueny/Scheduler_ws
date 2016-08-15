class AddAcceptMessagesFromToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :accept_messages_from, :integer, default: 1
  end
end
