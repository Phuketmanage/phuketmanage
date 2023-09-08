class ApplicationController < ActionController::Base
  before_action :set_settings

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  private

  def set_settings
    @settings = Setting.all.map { |s| [s.var, s.value] }.to_h
  end

  rescue_from ActiveRecord::RecordNotFound do
    render '/errors/not_found', status: :not_found
  end

  def append_info_to_payload(payload)
    super
    payload[:host] = request.host
    payload[:x_forwarded_for] = request.env['HTTP_X_FORWARDED_FOR']
  end

  protected

  def authenticate_inviter!
    unless user_signed_in? && current_user.role?(:admin)
      redirect_to root_path, alert: 'You are not authorized to access this page.' and return
    end

    super
  end

  def after_sign_in_path_for(_resource)
    if current_user.role?('Owner')
      transactions_path
    elsif current_user.role?('Accounting')
      transactions_path
    elsif current_user.role?('Guest relation')
      jobs_path
    elsif current_user.role?('Maid')
      laundry_path
    elsif current_user.role?('Gardener')
      water_usages_path
    else
      dashboard_path
    end
    # return the path based on resource
  end
end
