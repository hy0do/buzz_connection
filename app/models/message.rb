class Message < ApplicationRecord
  belongs_to :message_room
  belongs_to :user

  validates :text, presence: true
  validate :corrent_user

  before_create :timestamp
  after_create :broadcast

  private

  def corrent_user
    message_room.users.include?(user)
  end

  def timestamp
    self.posted_at = Time.zone.now
  end

  def broadcast
    payload = ActiveModelSerializers::SerializableResource.new(self, include: [:user])
    ActionCable.server.broadcast message_room.name, payload
  end
end
