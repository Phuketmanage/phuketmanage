Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ru/, defaults: { locale: nil } do
    root to: 'pages#index', as: :locale_root
    get 'report/bookings', to: 'reports#bookings'
    get 'report/balance', to: 'reports#balance'
    get 'report/salary', to: 'reports#salary'
    get 'reports', to: 'reports#index'
    get 'unlock', to: 'dev#unlock' if Rails.env.development?
    get 'houses/inactive', to: 'houses#inactive'
    resources :notifications, only: [:destroy]
    resources :water_usages
    get 'users/get_houses', to: 'users#get_houses' # , as: 'get_houses'
    get 'users/inactive', to: 'users#inactive'
    get 'documents/reimbersment', to: 'documents#reimbersment', as: 'tmp_reimbersment'
    get 'documents/statement', to: 'documents#statement', as: 'tmp_statement'
    resources :house_groups
    delete 'transaction_file', to: 'transaction_files#destroy'
    delete 'transaction_file_tmp', to: 'transaction_files#destroy_tmp'
    get 'transaction_file_download', to: 'transaction_files#download'
    get 'transaction_file_toggle_show', to: 'transaction_files#toggle_show'
    get 'transaction_files', to: 'transaction_files#index'
    get 'transaction_warnings', to: 'transactions#warnings'
    get 'transaction_raw_for_acc', to: 'transactions#raw_for_acc'
    get 'jobs/index_new', to: 'jobs#index_new', as: 'jobs_new'
    get 'laundry', to: 'jobs#laundry', as: 'laundry'
    patch 'jobs/:id/update_laundry', to: 'jobs#update_laundry', as: 'update_laundry'
    get 'jobs/job_order', to: 'jobs#job_order', as: 'job_order'
    resources :jobs
    resources :job_types, except: :show
    post 'job_messages', to: 'job_messages#create'
    delete 'job_message', to: 'job_messages#destroy'
    get 'logs', to: 'logs#index'
    get 'test', to: 'pages#test'
    resources :locations, except: :show
    resources :options, except: :show
    get 'owner', to: 'admin#index', as: 'owner'
    resources :transactions, except: [:show]
    get 'transactions_docs', to: 'transactions#docs', as: 'transactions_docs'
    post 'transactions/update_invoice_ref', to: 'transactions#update_invoice_ref', as: 'update_invoice_ref'
    get 'balance', to: 'transactions#index', as: 'balance_front'
    resources :transaction_types
    get '/employees/list_for_job', to: 'employees#list_for_job'
    resources :employees
    resources :empl_types
    get '/transfers/:number/confirmed', to: 'transfers#confirmed', as: 'supplier_confirm_transfer'
    get '/transfers/:number/canceled', to: 'transfers#canceled', as: 'supplier_cancel_transfer'
    get '/transfers/supplier', to: 'transfers#index_supplier', as: 'transfers_supplier'
    resources :houses do
      resources :prices, only: [:index]
      get 'photos', to: 'house_photos#index', as: 'photos'
      get 'photos/add', to: 'house_photos#add'
      get 'export', on: :collection
    end
    put 'house_photos/:id/sort', to: 'house_photos#sort', as: 'house_photos_sort'
    delete 'house_photos/:id', to: 'house_photos#delete', as: 'house_photo_delete'
    delete 'houses/:hid/delete_photos', to: 'house_photos#delete', as: 'house_photo_delete_all'
    patch 'house_photos/:id', to: 'house_photos#update', as: 'house_photo_update'
    get 'bookings/get_price', to: 'bookings#get_price'
    post 'booking/new', to: 'bookings#create_front'
    get 'bookings/sync', to: 'bookings#sync', as: 'booking_sync'
    get 'bookings/timeline', to: 'bookings#timeline', as: 'bookings_timeline'
    get 'bookings/timeline_data', to: 'bookings#timeline_data'
    get 'bookings/check_in_out', to: 'bookings#check_in_out', as: 'bookings_check_in_out'
    get 'bookings/canceled', to: 'bookings#canceled'
    # get 'bookings/salary', to: 'bookings#salary_index', as: 'salary_index'
    # get 'bookings/salary_calc', to: 'bookings#salary_calc', as: 'salary_calc'
    patch 'bookings/:id/update_comment_gr', to: 'bookings#update_comment_gr', as: 'update_booking_comment_gr'
    get 'owner/bookings', to: 'bookings#index_front', as: 'bookings_front'
    resources :bookings
    resources :booking_files, only: %i[create update destroy]
    get '/about', to: 'pages#about', as: 'page_about'
    devise_for :users
    resources :users, except: :create
    post 'create_user', to: 'users#create', as: 'create_user'
    get 'users/:id/password_reset_request', to: 'users#password_reset_request', as: 'password_reset_request'
    get 'test_upload', to: 'houses#test_upload'
    get 'prices/:id/update', to: 'prices#update', as: 'price'
    post 'houses/:house_id/add_duration', to: 'prices#create_duration', as: 'add_duration'
    delete 'houses/:house_id/delete_duration', to: 'prices#destroy_duration', as: 'delete_duration'
    post 'houses/:house_id/add_season', to: 'prices#create_season', as: 'add_season'
    delete 'houses/:house_id/delete_season', to: 'prices#destroy_season', as: 'delete_season'
    get 'houses/:hid/bookings', to: 'bookings#index', as: 'house_bookings'
    get 'houses/:hid/bookings/new', to: 'bookings#new', as: 'new_house_booking'
    post 'prices/:house_id/copy_table', to: 'prices#copy_table', as: 'copy_table'
    get 'dashboard', to: 'admin#index', as: 'dashboard'
    get 'owner', to: 'owner#index'
    get 'tenant', to: 'tenant#index'
    get 'calendar/ical/:hid', to: 'bookings#ical', as: 'calendar'
    get 'search', to: 'search#index'
    resources :settings
    resources :house_types
    resources :sources, except: :show
    resources :connections, only: %i[create destroy]
    get '/transfers/:id/cancel', to: 'transfers#cancel', as: 'cancel_transfer'
    resources :transfers
    get 'translate', to: "translations#show"
  end
  root to: 'pages#index'

  # Good job admin dashboard
  authenticate :user, ->(user) { user.role?('Admin') } do
    mount GoodJob::Engine => '/admin/activejob'
    resources :uploads_tests # TODO: Remove after #353
  end

  # Errors
  match "/422", to: "errors#unprocessable_content", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "*unmatched", to: "errors#not_found", via: :all, constraints: lambda { |req|
    req.path.exclude? '/files'
  }
end
