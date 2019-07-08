Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/:locale' , to: 'pages#index'
    devise_for :users
    resources :bookings
    resources :houses do
      resources :prices, only: [:index]
      # resources :seasons, except: [:show, :new, :create, :edit, :update], shallow: true
      # resources :durations, except: [:show, :new, :create, :edit, :update], shallow: true
    end
    get 'prices/:id/update', to: 'prices#update', as: 'price'
    post 'houses/:house_id/add_duration', to: 'prices#create_duration', as: 'add_duration'
    delete 'houses/:house_id/delete_duration', to: 'prices#destroy_duration', as: 'delete_duration'
    post 'houses/:house_id/add_season', to: 'prices#create_season', as: 'add_season'
    delete 'houses/:house_id/delete_season', to: 'prices#destroy_season', as: 'delete_season'
    get 'houses/:house_id/bookings', to: 'bookings#index', as: 'house_bookings'
    post 'prices/:house_id/copy_table', to: 'prices#copy_table', as: 'copy_table'

    get 'dashboard', to: 'admin#index'
    get 'owner', to: 'owner#index'
    get 'tenant', to: 'tenant#index'
    resources :users, except: :create
    post 'create_user', to: 'users#create', as: 'create_user'
    get 'calendar/ical/:ical_name', to: 'bookings#ical'
    get 'search', to: 'search#index'
    resources :settings
    resources :house_types
    resources :sources
  end

  root to: 'pages#index'
end
