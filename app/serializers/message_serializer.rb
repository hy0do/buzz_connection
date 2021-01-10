class MessageSerializer < ActiveModel::Serializer
  attributes :id, :message_room_id, :user_id, :text, :posted_at
  has_one :user
end
