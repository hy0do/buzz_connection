class UserPlan < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  class << self
    def current(user)
      where(user: user).order(start_at: :desc).first&.plan || Plan.default
    end

    def from_today(args = {})
      today = Date.today
      attributes = {
        start_at: today,
        end_at: today + 30.days
      }
      new(attributes)
    end
  end
end
