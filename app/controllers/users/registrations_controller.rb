class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :check_permissions, :only => [ :new, :create, :cancel ]
  # skip_before_action :require_no_authentication

  # def check_permissions
  #   authorize! :create, resource
  # end
  # load_and_authorize_resource
end
