class UsersController < ApplicationController
  layout 'pages'
  before_filter :authenticate, :only => [:edit, :update, :show, :index] 
  before_filter :correct_user, :only => [:edit, :update]
  def new
     @user = User.new
    @title = "Sign up"
  end

  def index
    @user = User.all
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user]) 
    if @user.save
      sign_in @user
    flash[:success] = "Want to rent my tent?"
    redirect_to @user  
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit User"
  end

  def update
    @user = User.find(params[:id])
  if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
  else
      @title = "Edit user"
      render 'edit'
  end 

end

private


  def authenticate
    deny_access unless signed_in?

  end

  def correct_user
    @user = User.find(params[:id]) 
    redirect_to current_user unless current_user?(@user)
    flash[:error] = "No permission to edit foreign profiles" unless current_user?(@user)
  end

end
