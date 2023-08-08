class UsersController < ApplicationController
  load_and_authorize_resource
  layout 'admin'
  # @route GET (/:locale)/users {locale: nil} (users)
  def index
    if params['role']
      @users = User.with_role(params['role']).order(:name)
    elsif current_user.role? :admin
      @users = User.active_owners.order(:name)
    elsif current_user.role? :manager
      @users = User.with_role(%w[Owner Tenant]).order(:name)
    end
  end

  # @route GET (/:locale)/users/inactive {locale: nil} (users_inactive)
  def inactive
    @users = User.inactive_owners.order(:name)
  end

  # @route GET (/:locale)/users/new {locale: nil} (new_user)
  def new
    @user = User.new
    @roles = if current_user.role? :admin
      Role.all
    else
      Role.where(name: %w[Owner Tenant]).all
    end
  end

  # @route GET (/:locale)/users/:id/edit {locale: nil} (edit_user)
  def edit
    @user = User.find(params[:id])
    @roles = if current_user.role? :admin
      Role.all
    else
      Role.where(name: %w[Owner Tenant]).all
    end
  end

  # @route POST (/:locale)/create_user {locale: nil} (create_user)
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Successfully created User."
      redirect_to users_path
    else
      @roles = if current_user.role? :admin
        Role.all
      else
        Role.where(name: %w[Owner Tenant]).all
      end
      render action: 'new'
    end
  end

  # @route PATCH (/:locale)/users/:id {locale: nil} (user)
  # @route PUT (/:locale)/users/:id {locale: nil} (user)
  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      flash[:notice] = "Successfully updated User."
      redirect_to users_path
    else
      @roles = Role.where(name: %w[Owner Tenant]).all
      render action: 'edit'
    end
  end

  # @route DELETE (/:locale)/users/:id {locale: nil} (user)
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to users_path
    end
  end

  # @route GET (/:locale)/users/:id/password_reset_request {locale: nil} (password_reset_request)
  def password_reset_request
    user = User.find(params[:id])
    user.send_reset_password_instructions
    redirect_to users_path
  end

  # @route GET (/:locale)/users/get_houses {locale: nil} (users_get_houses)
  def get_houses
    @owner_id = params[:owner_id]
    @houses = if @owner_id
      User.find(@owner_id).houses.active.select(:id, :code)
    else
      []
    end
    render json: { houses: @houses }
  end

  private

  def user_params
    params.require(:user).permit(:email,
                                 :name,
                                 :surname,
                                 :locale,
                                 :password,
                                 :password_confirmation,
                                 { role_ids: [] },
                                 :comment,
                                 :code,
                                 :tax_no,
                                 :balance_closed,
                                 :show_comm)
  end
end
