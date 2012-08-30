# encoding: utf-8 
class UsersController < ApplicationController
  layout 'pages'
  before_filter :authenticate, :except => [:show, :new, :create]
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
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
    @micropost = Micropost.new
  end   

  def create
    @user = User.new(params[:user]) 
    if @user.save
      sign_in @user
    flash[:success] = "Check out the war area!"
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
        if params[:password] == params[:password_confirmation] && @user.has_password?(params[:password]) || current_user.admin?
          @user.destroy
          flash[:notice] = 'Account successfully removed'
          redirect_to root_path
          return
        else
          flash[:error] = 'Incorrect Password'
        end  
      end
  end

  def create_post
    @user = User.find(params[:id])
    if current_user?(@user)

      @user.microposts.new(params[:micropost])
      @user.save

    end
    redirect_to @user
  end

  def destroy
      if current_user.admin?
      @user = User.find(params[:id])
      if @user.destroy 
        @user.microposts.destroy
        flash[:notice] = 'Account successfully removed'
      else
        flash[:error] = 'Error has been detected'
      end
      redirect_to users_path
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page]) 
    render 'show_follow'
  end


private




  def correct_user
    unless current_user.admin?
      @user = User.find(params[:id]) 
      redirect_to current_user unless current_user?(@user)
      flash[:error] = "Insufficient Permission" unless current_user?(@user)
    end
  end

end
