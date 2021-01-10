class MessageRoomUser < ApplicationRecord
  belongs_to :message_room
  belongs_to :user
end
