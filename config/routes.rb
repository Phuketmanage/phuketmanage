Rails.application.routes.draw do

  get 'admin/index'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/:locale' , to: 'pages#index'
    devise_for :users
  end

  get 'dashboard', to: 'admin#index'
  get 'owner', to: 'owner#index'
  get 'tenant', to: 'tenant#index'
  resources :users, except: :create
  post 'create_user', to: 'users#create', as: 'create_user'
  namespace :admin do

  end

  root to: 'pages#index'
end
