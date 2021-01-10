module ConnectionService
  class CheckSession
    attr_reader :connection_request, :notifications, :notification

    def initialize(connection_request, user, strategy = nil)
      @connection_request = connection_request
      @notifications = connection_request.notifications
      @notification = @notifications.detect { |notification| notification.user == user }
      @strategy = strategy
    end

    def valid_session?
      @notification.checking?
    end

    def exec
      return false unless @strategy
      @strategy.new(self).exec
    end
  end
end