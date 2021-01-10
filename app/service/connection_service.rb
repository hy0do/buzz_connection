module ConnectionService
  extend self

  def new_request(connection_request_params)
    ConnectionRequest.new(connection_request_params).tap(&:build_notifications)
  end

  def new_check_session(connection_request:, user:)
    CheckSession.new(connection_request, user)
  end

  def new_approve(connection_request:, user:)
    CheckSession.new(connection_request, user, Approve)
  end

  def new_reject(connection_request:, user:)
    CheckSession.new(connection_request, user, Reject)
  end
end
