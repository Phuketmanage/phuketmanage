class UsersController < ApplicationController
  load_and_authorize_resource
  layout 'admin'
  # @route GET (/:locale)/users (users)
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

  # @route GET (/:locale)/users/new (new_user)
  def new
    @user = User.new
    if current_user.role? :admin
      @roles = Role.all
    else
      @roles = Role.where(name: ['Owner', 'Tenant']).all
    end
  end

  # @route POST (/:locale)/create_user (create_user)
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

  # @route GET (/:locale)/users/:id/edit (edit_user)
  def edit
    @user = User.find(params[:id])
    if current_user.role? :admin
      @roles = Role.all
    else
      @roles = Role.where(name: ['Owner', 'Tenant']).all
    end
  end

  # @route PATCH (/:locale)/users/:id (user)
  # @route PUT (/:locale)/users/:id (user)
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

  # @route DELETE (/:locale)/users/:id (user)
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to users_path
    end
  end

  # @route GET (/:locale)/users/:id/password_reset_request (password_reset_request)
  def password_reset_request
    user = User.find(params[:id])
    user.send_reset_password_instructions
    redirect_to users_path
  end

  # @route GET /users/get_houses (users_get_houses)
  def get_houses
    @owner_id = params[:owner_id]
    if !@owner_id
      @houses = []
    else
      @houses = User.find(@owner_id).houses.select(:id, :code)
    end
    render json: { houses:  @houses }
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
                                    :tax_no,
                                    :show_comm)
    end

end
