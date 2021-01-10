class UsersController < ApplicationController
  def show
    @user = User.find_by!(code: params[:code])
  end
end
