class Message < ApplicationRecord

  belongs_to :user
  belongs_to :chat_room, touch: true

end
