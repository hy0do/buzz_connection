module ConnectionService
  class Approve < CheckStrategy
    def exec
      ActiveRecord::Base.transaction do
        @notification.approved!

        if @notifications.all?(&:approved?)
          Rails.logger.debug('[DEBUG] All Approved.')
          @connection_request.approved! 
          message_room = MessageRoom.create!
          message_room.users = @connection_request.users

          add_point if @connection_request.introduce?
        end
        # メール送信
      end
      true
    rescue => e
      Rails.logger.error(e.inspect)
      Rails.logger.error(e.backtrace)
      false
    end
  end
end
