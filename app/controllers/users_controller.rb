# encoding: utf-8 
class UsersController < ApplicationController
  layout 'pages'
  before_filter :authenticate, :only => [:edit, :update, :show, :delete_form] 
  before_filter :correct_user, :only => [:edit, :update, :delete_form]
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
    flash[:success] = "Want to rent my tent"
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
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end 
  end

  def delete_form
    @user = User.find(params[:id])
    if request.post?
      if params[:password] == params[:password_confirmation] && @user.has_password?(params[:password])
        @user.destroy
        flash[:notice] = 'Account successfully removed'
        redirect_to root_path
        return
      else
        flash[:error] = 'Incorrect Password'
      end  
    end
  end

private


  def authenticate
    deny_access unless signed_in?

  end

  def correct_user
    @user = User.find(params[:id]) 
    redirect_to current_user unless current_user?(@user)
    flash[:error] = "Insufficient Permission" unless current_user?(@user)
  end

end
