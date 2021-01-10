class PlansController < ApplicationController
  before_action :user_login!
  before_action :find_plan

  def index
  end

  def create
    if @current_plan.id < params[:plan_id].to_i
      new_plan = UserPlan.from_today # FIXME: 現在のプランの残りから計算
      new_plan.user = @current_user
      new_plan.plan_id = params[:plan_id]
      new_plan.save
    end
    redirect_to profile_path # FIXME: お支払い
  end

  private

  def find_plan
    @current_plan ||= current_user.plan
  end
end
