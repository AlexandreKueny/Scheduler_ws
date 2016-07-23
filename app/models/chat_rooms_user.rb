class ChatRoomsUser < ApplicationRecord

  belongs_to :user
  belongs_to :chat_room

  scope :current, -> { where(deleted: false)}

end
