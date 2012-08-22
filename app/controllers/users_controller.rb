class UsersController < ApplicationController
  layout 'pages'
  
  def new
  end

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

end
