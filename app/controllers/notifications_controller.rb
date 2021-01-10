class NotificationsController < ApplicationController
  def index
    notification_models = [*Notification.all] # FIXME: 種類分け
    notification_models.concat(current_user.connection_notifications) if user_login?
    @notifications = notification_models.sort_by(&:created_at)
  end
end
