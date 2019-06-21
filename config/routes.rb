Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/:locale' , to: 'pages#index'
    # devise_for :users
    devise_for :users, :controllers => { :registrations => "users/registrations" }
  end
  namespace :admin do
    resources :users
    # get 'users', to: 'users#index'
  end

  root to: 'pages#index'
end
