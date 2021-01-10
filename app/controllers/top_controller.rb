class TopController < ApplicationController
  def index
    @users = User.eager_load(:business)
                 .merge(Business.published)
                 .yield_self { |q| user_login? ? q.where.not(id: current_user.id) : q }
                 .limit(10)
  end
end
