Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/:locale' , to: 'pages#index'
    # devise_for :users
    # devise_for :users, :controllers => { :registrations => "users/registrations" }
    # devise_for :users, controllers: { invitations: 'admin/invitations' }
    devise_for :users
  end

  namespace :admin do
    resources :users
    # get 'new_invite', to: 'users#new_invite', as: 'new_invite'
    # get 'users', to: 'users#index', as: 'users'
  end



  root to: 'pages#index'
end
