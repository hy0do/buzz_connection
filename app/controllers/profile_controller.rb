class ProfileController < ApplicationController
  before_action :user_login!
  before_action :signup, only: [:show, :edit]

  def show; end

  def edit; end

  def update
    current_user.assign_attributes(user_params)
    current_user.birthday = nil if current_user.age == 0
    current_user.save!
    redirect_to action: :show
  rescue => e
    flash.now[:alert] = e.message
    render :edit
  end

  private

  def user_params
    params.require(:user).permit(:name, :detail, :avatar_image, :cover_image, :birthday, :gender)
  end

  def signup
    @signup = session[:signup]
    session[:signup] = nil
  end
end
