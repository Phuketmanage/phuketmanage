class UsersController < ApplicationController
  load_and_authorize_resource
  layout 'admin'
  def index
    if params['role']
      @users = User.with_role(params['role']).order(:name)
    else
      if current_user.role? :admin
        @users = User.all.order(:name)
      elsif current_user.role? :manager
        @users = User.with_role(['Owner', 'Tenant']).order(:name)
      end
    end
  end

  def new
    @user = User.new
    if current_user.role? :admin
      @roles = Role.all
    else
      @roles = Role.where(name: ['Owner', 'Tenant']).all
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Successfully created User."
      redirect_to users_path
    else
      if current_user.role? :admin
        @roles = Role.all
      else
        @roles = Role.where(name: ['Owner', 'Tenant']).all
      end
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    if current_user.role? :admin
      @roles = Role.all
    else
      @roles = Role.where(name: ['Owner', 'Tenant']).all
    end
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?

    if @user.update(user_params)
      flash[:notice] = "Successfully updated User."
      redirect_to users_path
    else
      @roles = Role.where(name: ['Owner', 'Tenant']).all
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to users_path
    end
  end

  def password_reset_request
    user = User.find(params[:id])
    user.send_reset_password_instructions
    redirect_to users_path
  end

  private

    def user_params
       params.require(:user).permit(:email,
                                    :name,
                                    :surname,
                                    :locale,
                                    :password,
                                    :password_confirmation,
                                    { role_ids: []},
                                    :comment,
                                    :code,
                                    :tax_no)
    end

end
