class ApplicationController < ActionController::Base

  before_filter :expired?
  protect_from_forgery

  include SessionsHelper

   def sign_out
      cookies.delete(:remember_token)
      cookies.delete(:time)
      session[:return_to] = nil
      current_user = nil 
    end

  private

  def expired?
         if cookies.signed[:time].present?
           if Time.now.utc > (cookies.signed[:time] + 600)
            if !current_user.admin?
             flash[:success] = "Your Session has been expired! Please Sign in again!"
             sign_out
             redirect_to root_path
           else
            cookies.signed[:time] = Time.now.utc
            flash[:success] = "The expired? function triggerd within the last seconds"
          end
       end
     end
  end
end
