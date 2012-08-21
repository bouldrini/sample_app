class UsersController < ApplicationController
<<<<<<< HEAD
  layout 'pages'
=======
   layout 'pages'
>>>>>>> eccd0f5a846c1470be078a145317fbe1a79f1a71
  
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
