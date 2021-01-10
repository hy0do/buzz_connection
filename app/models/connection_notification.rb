class ConnectionNotification < ApplicationRecord
  belongs_to :user
  belongs_to :connection_request

  enum status: {
    rejected: 0,
    checking: 1,
    approved: 2
  }

  def self.builds(connection_request)
    builder = Builder.new
    builder.connection_request = connection_request
    builder.connection_notifications
  end

  class Builder
    attr_reader :connection_notifications

    def initialze(connection_notifications = ConnectionNotification.none)
      @connection_notifications = connection_notifications
    end

    def connection_request=(connection_request)
      @connection_notifications = connection_request.notifications

      case connection_request.connection_type
      when 'direct'
        add_direct_notifications(connection_request)
      when 'introduce'
        add_introduce_notifications(connection_request)
      end
      connection_request
    end

    private

    # 1ユーザーにお知らせ配信
    def add_direct_notifications(connection_request)
      notification = ConnectionNotification.new
      notification.user = connection_request.to_user
      @connection_notifications << notification
    end

    # 2ユーザーにお知らせ配信
    def add_introduce_notifications(connection_request)
      [:from_user, :to_user].map do |user_type|
        notification = ConnectionNotification.new
        notification.user = connection_request.send(user_type)
        @connection_notifications << notification
      end
    end
  end
end
