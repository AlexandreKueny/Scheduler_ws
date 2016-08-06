class ChatRoomsUser < ApplicationRecord

  belongs_to :user
  belongs_to :chat_room

  scope :current, -> { where(deleted: false)}
  scope :unread, ->(state) {state ? where('unread > 0') : where('unread = 0')}

end
