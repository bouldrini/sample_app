class MicropostsController < ApplicationController
  layout 'pages'

  def new
    @user = User.find params[:user_id]
    @micropost = Micropost.new
  end

  def create
    @user = User.find params[:user_id]
    @micropost = Micropost.new(params[:micropost])
    @micropost.user = @user
    if @micropost.save
    end
    redirect_to user_path(@user) 
  end 

  def destroy 
      @user = User.find(params[:user_id])
      @micropost = Micropost.find_by_user_id(params[:user_id])
      @micropost.user = @user
      if @user = current_user
        if @micropost.destroy
          flash[:notice] = 'Post successfully deleted'
        else
          flash[:error] = 'Error has been detected'
        end
      redirect_to user_path(@user)
    end
  end
end
