# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  root to: 'guests/index#index'

  scope "(:locale)" do
    devise_for :users, controllers: { sessions: "users/sessions", passwords: "users/passwords" }
  end

  # Guests controllers
  scope "(:locale)", module: 'guests', as: 'guests', locale: /ru/ do
    root to: 'index#index', as: :locale_root
    resources :houses, only: %i[show index]
    get :about, to: 'about#index'
  end

  # Admin controllers
  scope module: 'admin' do
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    get 'report/bookings', to: 'reports#bookings'
    get 'report/balance', to: 'reports#balance'
    get 'report/salary', to: 'reports#salary'
    get 'report/income', to: 'reports#income'
    get 'reports', to: 'reports#index'
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
    get 'transaction_raw', to: 'transactions#raw'
    get 'jobs/index_new', to: 'jobs#index_new', as: 'jobs_new'
    get 'laundry', to: 'jobs#laundry', as: 'laundry'
    patch 'jobs/:id/update_laundry', to: 'jobs#update_laundry', as: 'update_laundry'
    get 'jobs/job_order', to: 'jobs#job_order', as: 'job_order'
    resources :jobs
    resources :job_types, except: :show
    post 'job_messages', to: 'job_messages#create'
    delete 'job_message', to: 'job_messages#destroy'
    get 'logs', to: 'logs#index'
    # get 'test', to: 'pages#test'
    resources :locations, except: :show
    resources :options, except: :show
    # get 'owner', to: 'admin#index', as: 'owner'
    get 'transactions/all_clients', to: 'transactions#all_clients', as: 'all_clients'
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
    resources :houses, path: 'admin_houses', as: 'admin_houses' do
      resources :prices, only: [:index]
      resources :photos, only: %i[index new destroy update] do
        put 'sort', on: :member
        delete 'delete_all', on: :collection
      end
      post 'add_duration', to: 'prices#create_duration'
      delete 'delete_duration', to: 'prices#destroy_duration'
      post 'add_season', to: 'prices#create_season'
      delete 'delete_season', to: 'prices#destroy_season'
      resources :bookings, only: %i[index new]
      get 'inactive', to: 'houses#inactive', on: :collection
      get 'export', on: :collection
    end
    post 'booking/new', to: 'bookings#create_front'
    get 'owner/bookings', to: 'bookings#index_front', as: 'bookings_front'
    resources :bookings do
      collection do
        get 'get_reservations'
        get 'get_price'
        get 'canceled'
        get 'timeline'
        get 'timeline_data'
        get 'check_in_out'
        get 'sync'
      end
      member do
        resources :booking_files, only: %i[create destroy], shallow: true
        patch 'update_comment_gr'
      end
    end
    resources :users, except: :create
    post 'create_user', to: 'users#create', as: 'create_user'
    get 'users/:id/password_reset_request', to: 'users#password_reset_request', as: 'password_reset_request'
    get 'test_upload', to: 'houses#test_upload'
    get 'prices/:id/update', to: 'prices#update', as: 'price'
    post 'prices/:house_id/copy_table', to: 'prices#copy_table', as: 'copy_table'
    # get 'owner', to: 'owner#index'
    # get 'tenant', to: 'tenant#index'
    get 'search', to: 'search#index'
    resources :settings
    resources :house_types
    resources :sources, except: :show
    resources :connections, only: %i[create destroy]
    get '/transfers/:id/cancel', to: 'transfers#cancel', as: 'cancel_transfer'
    resources :transfers
    get 'translate', to: "translations#show"
    get 'calendar/ical/:hid', to: 'bookings#ical', as: 'calendar'
  end

  get 'unlock', to: 'dev#unlock' if Rails.env.development?

  # Admin dashboards
  authenticate :user, ->(user) { user.role?('Admin') } do
    mount GoodJob::Engine => '/admin/activejob'
    resources :uploads_tests # TODO: Remove after #353
    mount MaintenanceTasks::Engine => "/admin/maintenance_tasks"
  end

  # Errors
  match "/422", to: "errors#unprocessable_content", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "*unmatched", to: "errors#not_found", via: :all, constraints: lambda { |req|
    req.path.exclude? '/files'
  }
end
# rubocop:enable
