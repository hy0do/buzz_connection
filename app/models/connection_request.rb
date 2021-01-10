class ConnectionRequest < ApplicationRecord
  has_many :notifications, class_name: 'ConnectionNotification', dependent: :destroy
  accepts_nested_attributes_for :notifications

  belongs_to :connector, class_name: 'User', foreign_key: :connector_id, required: false
  belongs_to :from_user, class_name: 'User', foreign_key: :from_user_id, required: false
  belongs_to :to_user, class_name: 'User', foreign_key: :to_user_id, required: false

  enum connection_type: {
    direct: 0,
    introduce: 1
  }

  enum status: {
    rejected: 0,
    checking: 1,
    approved: 2
  }

  attr_accessor :session_id, :candidate_list

  # つながりリクエスト
  # from_userからto_userへ直接のつながり申請
  # connectorはnilになる
  with_options if: :direct? do
    validates :from_user, presence: true
    validates :to_user, presence: true
    validates :from_user, uniqueness: { scope: [:to_user] }
  end

  # 紹介リクエスト:初期状態
  # connectorがto_userへ紹介
  # from_userはまだ未選択のためnilになる
  # 紹介できる人がいなければエラー
  with_options if: :introduce?, on: :new do
    validate :any_candidate
    validates :connector, presence: true
    validates :to_user, presence: true
  end

  # 紹介リクエスト:登録
  # connectorがfrom_userをto_userへ紹介
  with_options if: :introduce?, on: :create do
    validates :connector, presence: true
    validates :from_user, presence: true
    validates :to_user, presence: true
    validates :from_user, uniqueness: { scope: [:connector, :to_user] }
  end

  validate :except_default_plan
  validate :new_connection
  validate :not_full_friend

  before_create :reset_code

  delegate :name, to: :connector, prefix: true
  delegate :name, to: :from_user, prefix: true
  delegate :name, to: :to_user, prefix: true

  def self.build(user:, user_code:, type:)
    builder = Builder.new(new(connection_type: type))
    builder.user_code = user_code
    builder.user = user # CAUTION: user.code != user_code
    builder.connection_request
  end

  def build_notifications
    ConnectionNotification.builds(self)
  end

  def user_type(user)
    [:connector, :from_user, :to_user].detect do |user_type|
      user == self.send(user_type)
    end
  end

  # override
  def to_param
    code
  end

  # return array
  def users
    [:connector, :from_user, :to_user].map do |user_type|
      self.send(user_type)
    end.compact
  end

  private

  def reset_code
    self.code = SecureRandom.hex(10).upcase
  end

  # 紹介できる人がいなければつながり申請できない
  def any_candidate
    return if candidate_list.nil?
    if candidate_list.count.zero?
      errors.add(:to_user, 'に紹介できる人がいません')
    end
  end

  # すでにつながっている場合はつながり申請できない
  def new_connection
    return unless [from_user, to_user].all?
    if from_user.has_connection?(to_user)
      errors.add(:to_user, 'はすでにつながっています')
    end
  end

  # つながりリストがいっぱいなら新たなつながり申請ができない
  def not_full_friend
    users = {
      from_user: from_user,
      to_user: to_user
    }
    users[:connector] = connector if introduce?
    return unless users.values.all?

    users = users.map do |name, user|
      [name, user.full_friend?]
    end.to_h

    full_user = users.detect { |_k, v| v }
    if full_user.present?
      errors.add(full_user[0], 'はつながり申請を受けられません(1)')
    end
  end

  # フリープランは紹介を受けられない
  def except_default_plan
    if introduce? && to_user.plan.default?
      errors.add(:to_user, 'はつながり申請を受けられません(2)')
    end
  end


  class Builder
    attr_accessor :connection_request

    def initialize(connection_request)
      @connection_request = connection_request
      @connection_request.session_id = SecureRandom.hex(8)
    end

    def user_code=(user_code)
      to_user = User.find_by(code: user_code)
      connection_request.to_user = to_user
    end

    def user=(user)
      case connection_request.connection_type
      when 'direct'
        connection_request.from_user = user
      when 'introduce'
        connection_request.connector = user
        apply_candidate_list!
      end
    end

    private

    # 紹介できるユーザーのリスト
    def apply_candidate_list!
      to_user = connection_request.to_user
      connection_request.candidate_list = 
        connection_request.connector.friends.where.not(id: [to_user.id] | to_user.friends.ids)
    end
  end
end
