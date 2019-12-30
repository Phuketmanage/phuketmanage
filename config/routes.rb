Rails.application.routes.draw do

  get 'logs', to: 'logs#index'
  get 'test', to: 'pages#test'
  resources :locations, except: :show
  resources :options, except: :show
  # namespace :house do
  #   get 'photos/index'
  # end
  get 'owner', to: 'admin#index', as: 'owner'
  resources :transactions, except: [:show]
  post 'transactions/update_invoice_ref', to: 'transactions#update_invoice_ref', as: 'update_invoice_ref'
  get 'balance', to: 'transactions#index', as: 'balance_front'
  resources :transaction_types
  get '/employees/list_for_job', to: 'employees#list_for_job'
  resources :employees
  resources :empl_types
  get '/transfers/:number/confirmed', to: 'transfers#confirmed', as: 'supplier_confirm_transfer'
  get '/transfers/:number/canceled', to: 'transfers#canceled', as: 'supplier_cancel_transfer'
  get '/transfers/supplier', to: 'transfers#index_supplier', as: 'transfers_supplier'
  resources :houses, except: :show do
    resources :prices, only: [:index]
    get 'photos', to: 'house_photos#index', as: 'photos'
    get 'photos/add', to: 'house_photos#add'
    # resources :seasons, except: [:show, :new, :create, :edit, :update], shallow: true
    # resources :durations, except: [:show, :new, :create, :edit, :update], shallow: true
  end
  delete 'house_photos/:id', to: 'house_photos#delete', as: 'house_photo_delete'
  delete 'houses/:hid/delete_photos', to: 'house_photos#delete', as: 'house_photo_delete_all'
  patch 'house_photos/:id', to: 'house_photos#update', as: 'house_photo_update'
  post 'booking/new', to: 'bookings#create_front'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/:locale' , to: 'pages#index'
    devise_for :users
    resources :users, except: :create
    post 'create_user', to: 'users#create', as: 'create_user'
    get 'users/:id/password_reset_request', to: 'users#password_reset_request', as: 'password_reset_request'
    resources :houses, only: :show
    get 'bookings/sync', to: 'bookings#sync', as: 'booking_sync'
    get 'bookings/timeline', to: 'bookings#timeline', as: 'bookings_timeline'
    get 'bookings/timeline_data', to: 'bookings#timeline_data'
    get 'bookings/check_in_out', to: 'bookings#check_in_out', as: 'bookings_check_in_out'
    patch 'bookings/:id/update_comment_gr', to: 'bookings#update_comment_gr', as: 'update_booking_comment_gr'
    resources :bookings
    get 'owner/bookings', to: 'bookings#index_front', as: 'bookings_front'
    get 'test_upload', to: 'houses#test_upload'
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
    get 'calendar/ical/:ical_name', to: 'bookings#ical'
    get 'search', to: 'search#index'
    resources :settings
    resources :house_types
    resources :sources, except: :show
    resources :connections, only: [:create, :destroy]
    get 'jobs/index_new', to: 'jobs#index_new', as: 'jobs_new'
    get 'laundry', to: 'jobs#laundry', as: 'laundry'
    patch 'jobs/:id/update_laundry', to: 'jobs#update_laundry', as: 'update_laundry'
    resources :jobs, except: :show
    resources :job_types, except: :show
    get '/transfers/:id/cancel', to: 'transfers#cancel', as: 'cancel_transfer'
    resources :transfers
    end
  root to: 'pages#index'
end
