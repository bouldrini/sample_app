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
    else
    end
    redirect_to user_path(@user) 
  end

end
