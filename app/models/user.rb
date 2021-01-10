class User < ApplicationRecord
  has_many :external_credentials
  has_many :user_connections
  has_many :friends, through: :user_connections, foreign_key: :friend_id
  has_many :user_plans
  has_many :plans, through: :user_plans
  has_many :connection_notifications
  has_many :message_room_users
  has_many :message_rooms, through: :message_room_users
  has_many :messages
  has_one :business
  belongs_to :prefecture, required: false

  before_create :reset_code
  after_create :create_business

  validates :name, presence: true
  validates :email, presence: true

  enum status: {
    deleted: 0,
    active: 1
  }

  enum gender: {
    unknown: 0,
    male: 1,
    female: 2
  }

  delegate :name, to: :prefecture, prefix: true, allow_nil: true
  delegate :name, to: :plan, prefix: true
  delegate :list_capacity, to: :plan

  mount_uploader :cover_image, CoverImageUploader
  mount_uploader :avatar_image, AvatarImageUploader

  def has_connection?(user)
    friends.include?(user)
  end

  def full_friend?
    (list_capacity - friends.count) <= 0
  end

  def age
    return unless birthday
    (Date.today.strftime('%Y%m%d').to_i - birthday.strftime('%Y%m%d').to_i) / 10000
  end

  def current_plan
    UserPlan.current(self)
  end
  alias plan current_plan

  def splited_code
    uuid.scan(/(.{4})(.{4})(.{4})(.{4})/)[0].join("-")
  end

  # override
  def to_param
    code
  end

  private

  def reset_code
    self.code = SecureRandom.hex(8).upcase
  end
end
