class ConnectionsController < ApplicationController
  before_action :user_login!

  class InvalidSession < StandardError; end

  def new
    @connection_request = ConnectionRequest.build(user: current_user, user_code: params[:user_code], type: params[:type])
    if @connection_request.valid?(:new)
      session[:connection_code] = @connection_request.session_id
      render :new
    else
      flash[:alert] = @connection_request.errors.full_messages[0]
      redirect_to request.referer
    end
  end

  def create
    raise InvalidSession unless session[:connection_code] == params[:session_id]
    service = ConnectionService.new_request(connection_request_params)

    if service.valid?
      flash[:notice] = 'つながりリクエストを送りました'
      service.save
    else
      flash[:alert] = service.errors.full_messages[0]
    end
    session[:connection_code] = nil
    redirect_to user_path(code: params[:code])
  end

  def edit
    @connection_request = ConnectionRequest.find_by!(code: params[:code])
    service = ConnectionService.new_check_session(connection_request: @connection_request, user: current_user)
    raise InvalidSession unless service.valid_session?

    @user_type = @connection_request.user_type(current_user)
  end

  def approve
    connection_request = ConnectionRequest.find_by!(code: params[:code])
    service = ConnectionService.new_approve(connection_request: connection_request, user: current_user)
    raise InvalidSession unless service.valid_session?

    if service.exec
      flash[:notice] = '承認しました'
    else
      flash[:alert] = '不明なエラーが発生しました。運営にお問い合わせください。(C001)'
    end
    redirect_to notifications_path
  end

  def reject
    connection_request = ConnectionRequest.find_by!(code: params[:code])
    service = ConnectionService.new_reject(connection_request: connection_request, user: current_user)
    raise InvalidSession unless service.valid_session?

    if service.exec
      flash[:notice] = '拒否しました'
    else
      flash[:alert] = '不明なエラーが発生しました。運営にお問い合わせください。(C002)'
    end
    redirect_to notifications_path
  end

  private

  def connection_request_params
    params.require(:connection_request).permit(:connection_type, :connector_id, :from_user_id, :to_user_id)
  end
end