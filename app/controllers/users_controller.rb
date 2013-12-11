class UsersController < ApplicationController
  # make sure user is signed in when calling these user actions
  before_action :signed_in_user, only: [:index, :edit, :update]
  
  # make sure user is correct user, editing/updating his OWN user info not someone else's
  before_action :correct_user, only: [:edit, :update]
  
  # when destroying, make sure user is admin (private function below), otherwise redirect to root
  before_action :admin_user, only: [:destroy]
  
  def index
    #@users = User.all
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  

  def show
    @user = User.find(params[:id]) 
    @microposts = @user.microposts.paginate(page: params[:page])
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
  
  def edit
    #@user = User.find(params[:id])
  end
  
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end
  
  
  
  
  
  
  private
    def user_params
      # variation of params[:user]
      params.require(:user).permit(:name, :email, :password, 
                  :password_confirmation)
    end
    
    
    # Before filters
    
    #def signed_in_user
    #  redirect_to signin_url, notice: "Please sign in." unless signed_in?
    #end
    
    
    
    # check if user ID from url is same as the currently signed in user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
