module NotificationsHelper

  def notification_link(notification, user)
    item = NotificationItem.new(notification, user)
    link_to [item.text, item.datetime].join(' '), item.url
  end

  class NotificationItem
    include Rails.application.routes.url_helpers

    attr_reader :url, :text, :datetime

    LINK_MAP = {
      direct: {
        checking: {
          to_user: 'つながりリクエストが届いています。'
        },
        rejected: {
          from_user: 'つながりリクエストが拒否されました。'
        },
        approved: {
          from_user: 'つながりリクエストが承認されました。'
        }
      },
      introduce: {
        checking: {
          to_user: '紹介リクエストが届いています。',
          from_user: '紹介リクエストが届いています。'
        },
        rejected: {
          connector: '紹介が拒否されました。',
          from_user: '紹介が拒否されました。'
        },
        approved: {
          connector: '紹介リクエストが承認されました。',
          from_user: '紹介リクエストが承認されました。'
        }
      }
    }

    def initialize(model, user)
      case model.class.name
      when 'Notification'
        @url = model.url
        @text = model.text
        @datetime = datetime_format(Date.today)
      when 'ConnectionNotification'
        @url = edit_connection_path(model.connection_request)
        @text = connection_notification_text(model, user)
        @datetime = datetime_format(model.created_at)
      end
    end

    private

    def connection_notification_text(model, user)
      connection_type = model.connection_request.connection_type.to_sym
      connection_status = model.status.to_sym
      user_type = model.connection_request.user_type(user).to_sym

      LINK_MAP.dig(connection_type, connection_status, user_type)
    end

    def datetime_format(datetime)
      datetime.strftime("%Y/%m/%d")
    end
  end
end
