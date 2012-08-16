class PagesController < ApplicationController
  # layout 'pages'

  def home
    @title = "Home"
  end

  def contact
        @title = "Contact us"
  end

  def about
        @title = "About us"
  end

end
