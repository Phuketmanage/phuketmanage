Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/:locale' , to: 'pages#index'
    devise_for :users
    resources :bookings
    resources :houses do
      resources :prices, except: :show, shallow: true
      resources :seasons, except: :show, shallow: true
      resources :durations, except: :show, shallow: true
    end
    get 'dashboard', to: 'admin#index'
    get 'owner', to: 'owner#index'
    get 'tenant', to: 'tenant#index'
    resources :users, except: :create
    post 'create_user', to: 'users#create', as: 'create_user'
    get 'calendar/ical/:ical_name', to: 'houses#ical'
    get 'search', to: 'search#index'
    resources :settings

  end

  root to: 'pages#index'
end
