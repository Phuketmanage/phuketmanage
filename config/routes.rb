Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/:locale' , to: 'pages#index'
    devise_for :users
    resources :bookings
    resources :houses do
      resources :prices, except: [:show, :new], shallow: true
      resources :seasons, except: :show, shallow: true
      resources :durations, except: :show, shallow: true
    end
    get 'prices/:id/update_ajax', to: 'prices#update_ajax'
    post 'houses/:id/add_duration', to: 'prices#create_duration', as: 'add_duration'
    delete 'houses/:id/delete_duration', to: 'prices#destroy_duration', as: 'delete_duration'
    post 'houses/:id/add_season', to: 'prices#create_season', as: 'add_season'
    delete 'houses/:id/delete_season', to: 'prices#destroy_season', as: 'delete_season'
    get 'dashboard', to: 'admin#index'
    get 'owner', to: 'owner#index'
    get 'tenant', to: 'tenant#index'
    resources :users, except: :create
    post 'create_user', to: 'users#create', as: 'create_user'
    get 'calendar/ical/:ical_name', to: 'houses#ical'
    get 'search', to: 'search#index'
    resources :settings
    resources :house_types

  end

  root to: 'pages#index'
end
