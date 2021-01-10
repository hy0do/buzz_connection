module ConnectionService
  class Reject < CheckStrategy
    def exec
      ActiveRecord::Base.transaction do
        @notifications.each(&:rejected!)
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
