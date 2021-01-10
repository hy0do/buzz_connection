Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root 'top#index'

  # ログイン
  get 'login', to: "auth#new", as: "login"
  delete 'logout', to: "auth#destroy", as: "logout"
  match "auth/:provider/callback", to: "auth#create", as: "auth_callback", via: %i[get post]
  post 'auth_test', to: "auth#test_create", as: "auth_test"

  # コネクション
  resources :connections, only: %i[create edit], param: :code
  get "connections/:type/:user_code", to: "connections#new", as: :new_connection
  put "connections/:code/approve", to: "connections#approve", as: :approve_connection
  put "connections/:code/reject", to: "connections#reject", as: :reject_connection

  # プロフィール
  scope :profile do
    get "/", to: "profile#show", as: "profile"
    get "edit", to: "profile#edit", as: "edit_profile"
    patch "/", to: "profile#update"
    resource :my_business, only: %i[edit update]
  end

  resources :businesses, only: %i[index show], param: :code
  resources :users, only: %i[show], param: :code
  resources :plans, only: %i[index create]
  resources :payments, only: %i[new create]
  resources :notifications, only: %i[index]
  resources :message_rooms, only: %i[index show]

  # 静的ページ
  get "privacy", to: "static_pages#privacy"
  get "terms", to: "static_pages#terms"
end
