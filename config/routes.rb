Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/:locale' , to: 'pages#index'
    devise_for :users
    get 'bookings/sync', to: 'bookings#sync', as: 'booking_sync'
    get 'bookings/timeline', to: 'bookings#timeline', as: 'bookings_timeline'
    get 'bookings/timeline_data', to: 'bookings#timeline_data'
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
    get 'houses/:hid/bookings', to: 'bookings#index', as: 'house_bookings'
    get 'houses/:hid/bookings/new', to: 'bookings#new', as: 'new_house_booking'
    # post 'houses/:id/connections', to: 'houses#create_connection', as: 'add_connection'
    post 'prices/:house_id/copy_table', to: 'prices#copy_table', as: 'copy_table'

    get 'dashboard', to: 'admin#index', as: 'dashboard'
    get 'owner', to: 'owner#index'
    get 'tenant', to: 'tenant#index'
    resources :users, except: :create
    post 'create_user', to: 'users#create', as: 'create_user'
    get 'calendar/ical/:ical_name', to: 'bookings#ical'
    get 'search', to: 'search#index'
    resources :settings
    resources :house_types
    resources :sources, except: :show
    resources :connections, only: [:create, :destroy]
    resources :jobs, except: :show
    resources :job_types, except: :show
  end

  root to: 'pages#index'
end
