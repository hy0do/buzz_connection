module ConnectionService
  class CheckStrategy
    def initialize(check_session)
      @connection_request = check_session.connection_request
      @notifications = check_session.notifications
      @notification = check_session.notification
    end
  end
end
