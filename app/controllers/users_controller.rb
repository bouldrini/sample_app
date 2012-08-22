class UsersController < ApplicationController
  layout 'pages'
  
  def new
  end

  def index
    @user = User.all
  end

  def show
    id = 3
    @user = User.find(params[:id])
  end

end
