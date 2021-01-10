class ApplicationController < ActionController::Base
  before_action :user_login

  def user_login
    current_user
  end

  def user_login!
    redirect_to(login_path) unless current_user
  end

  def user_login?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id], code: session[:user_code])
  end
end
