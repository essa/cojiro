class ApplicationController < ActionController::Base
  protect_from_forgery

  # get current user
  def current_user
    @current_user
  end

end
