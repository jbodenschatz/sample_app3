class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :already_signed_in, only: [:new, :create]
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def destroy
    user_to_destroy = User.find(params[:id])
    if !current_user?(user_to_destroy)
      flash[:success] = "User #{user_to_destroy.name} destroyed."
      user_to_destroy.destroy
      redirect_to users_url
    else
      flash[:error] = "You cannot destroy your own user."
      redirect_to users_url
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Before filters
    
    # Set return_to location and redirect users to signin page when
    # they try to access a page that they must be signed in to view
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
    
    # Prevent users from editing and updating other users
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Make sure current user is admin
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    # Prevent logged in users from accessing signup and signin pages
    def already_signed_in
      redirect_to root_path if signed_in?
    end
end
