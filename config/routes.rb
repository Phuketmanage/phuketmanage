Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/:locale' , to: 'pages#index'
    devise_for :users
    resources :bookings
    resources :houses do
      resources :prices, except: :show, shallow: true
      resources :seasons, shallow: true
      resources :durations, shallow: true
    end
    get 'dashboard', to: 'admin#index'
    get 'owner', to: 'owner#index'
    get 'tenant', to: 'tenant#index'
    resources :users, except: :create
    post 'create_user', to: 'users#create', as: 'create_user'
    get 'calendar/ical/:ical_name', to: 'houses#ical'
    get 'search', to: 'search#index'
  end

  root to: 'pages#index'
end
