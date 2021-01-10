class UserConnection < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: :friend_id

  after_create :create_reverse_connection
  validate :not_myself

  private

  def not_myself
    errors.add(:friend_id, 'must not be yourself') if user_id == friend_id
  end

  def create_reverse_connection
    return if friend.has_connection?(user)
    self.class.find_or_create_by(user: friend, friend: user)
  end
end
