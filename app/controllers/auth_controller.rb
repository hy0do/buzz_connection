class AuthController < ApplicationController
  def new
    if user_login?
      redirect_to profile_path
    else
      render :new
    end
  end

  def test_create
    fail unless Rails.env.development?
    user = if params[:code].present?
      session[:signup] = false
      User.find_by(code: params[:code])
    else
      session[:signup] = true
      User.create(name: "User-#{SecureRandom.hex(4)}", email: 'test@test.com')
    end

    if user
      session[:user_id] = user.id
      session[:user_code] = user.code
      cookies.signed[:user_id] = user.id
      cookies.encrypted[:user_id] = user.id

      path = session[:signup] ? edit_profile_path : profile_path
      redirect_to path
    else
      render :new
    end
  end

  def create
    response = request.env["omniauth.auth"]
    credential = ExternalCredential.find_or_initialize_by(provider: response[:provider], uid: response[:uid])
    if credential.user
      session[:signup] = false
    else
      ActiveRecord::Base.transaction do
        user = create_user!(response)
        credential.user = user
        credential.token = response.dig(:credentials, :token)
        credential.expires_at = response.dig(:credentials, :expires_at)
        credential.save!
      end
      session[:signup] = true
    end
    user = credential.reload.user

    cookies.signed[:user_id] = user.id
    cookies.encrypted[:user_id] = user.id
    session[:user_id] = user.id
    session[:user_code] = user.code

    path = session[:signup] ? edit_profile_path : profile_path
    redirect_to path
  end

  def destroy
    session.delete(:user_id)
    session.delete(:user_code)
    current_user = nil
    redirect_to root_path
  end

  private

  def create_user!(response)
    name = case response.dig(:provider)
    when 'facebook'
      response.dig(:info, :name)
    when 'linkedin'
      [response.dig(:info, :last_name), response.dig(:info, :last_name)].join(' ')
    end
    user = User.create!(
      name: name,
      email: response.dig(:info, :email)
    )
  end
end
